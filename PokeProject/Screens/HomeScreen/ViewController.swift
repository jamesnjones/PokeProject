//
//  ViewController.swift
//  PokeProject
//
//  Created by james Jones on 20/06/2022.
//

import UIKit


class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var results : [Results] = [] // to save the results we get
    var filteredResults : [Results] = [] // for when we search and have filtered results
    var id: [Int] = [] // id of the pokemon
    var offset = 0 // this will be used when scrolling down and we want to load more pokemon
    var type : [String] = []
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Results>!
    
    let pokeTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .red
    label.text = "PokèDex"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: K.loadingPageSeen) {
        let destVC = LoadingPageVC()
        present(destVC, animated: true)
        } // this will only show the entry page once, then they click enter and we save that they have seen it below and it will no longer populate.
        UserDefaults.standard.setValue(true, forKey: K.loadingPageSeen)
        
        view.addSubview(pokeTitle)
        configureUI()
 
        navigationController?.navigationBar.prefersLargeTitles = false // Standard inline nav title

        configureCollectionView()
        configureDataSource()
        configureSearchController()
        getPokemon()
        
        navigationItem.title = pokeTitle.text
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textAttributes = [NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 1, green: 0.7469804883, blue: 0.3268558979, alpha: 1),
                              NSAttributedString.Key.font: UIFont(name: K.fontName, size: 24)!] as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
       
        // here we are setting specific attributes the page title, font, size and colour
    }
    
    func getPokemon() {
        // Initial network call to get all the pokemon for the first screen
        NetworkManager.network.getPokemon(endpoint: "pokemon/") { [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self.results.append(contentsOf: results.results!)
                    
                    self.updateData(on: self.results)
                case .failure(let error):
                    self.presentAlertOnMainThread(title: K.error, message: error.rawValue, buttonTitle: "OK")
                }
            }
        }
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search For Pokemon" // set search bars placeholder
        // setting up the search bar so we can filter the results we get
        navigationItem.searchController = searchController
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))  // created 3 column layout
        
        view.addSubview(collectionView)
        collectionView.delegate = self  // must be placed so the app knows when to listen and respond
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 15
        
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier) // this allows us to use the cell we created ourselves
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Results>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, results) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell // we want it to be the cell we created
            
            cell.pokeTitle.text = results.name
            cell.pokeTitle.backgroundColor = .purple
            cell.layer.cornerRadius = 15.0
            cell.layer.borderWidth = 0.0
            
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 2.5
            cell.layer.shadowOpacity = 0.6  // these 5 are all neccessary to create the shadow effect
            cell.layer.masksToBounds = false
            
            cell.backgroundColor = #colorLiteral(red: 0.9239473939, green: 0.917347312, blue: 0.9290018678, alpha: 1)
        
            // this call will allow us to get the image for each pokemon
            NetworkManager.network.getPokemonInfo(name: results.name!) { result in
                switch result {
                case .success(let image):
                    // using the extension we created we can simply apply the result and display the image
                    cell.image.downloaded(from: image.sprites!.front_default!)
                    self.id.append(image.id!)
                    
                case .failure(let error):
                    // if any errors we can show our custom alert to let user know
                    self.presentAlertOnMainThread(title: K.error, message: error.rawValue, buttonTitle: "OK")
                }
            }
            return cell
        })
    }
    
    func updateData(on results: [Results]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Results>()
        snapshot.appendSections([.main])
        snapshot.appendItems(results) // create a snapshot to set up inital set of data
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            pokeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokeTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pokeTitle.widthAnchor.constraint(equalTo: view.widthAnchor),
            pokeTitle.heightAnchor.constraint(equalToConstant: 50)
            // setting constraints
        ])
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentHeight - height {  // here i have written some logic to understand if the user has scrolled to the bottom on the screen and if they have the following network call will fire off
            self.offset += 20
            showLoadingView()
            // if this is fired off we will add 20 more pokemone to our collection view
        NetworkManager.network.getPokemon(endpoint: "pokemon/?offset=\(offset)&limit=20") { result in
            self.dismissLoadingView()
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let results):
                    print("\(offset)")
                    self.results.append(contentsOf: results.results!)
                    
                    self.updateData(on: self.results) // this is how we add them
                case .failure(let error):
                    self.presentAlertOnMainThread(title: K.error, message: error.rawValue, buttonTitle: "OK")
                }
            }
          }
       }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destVC = PokemonDetailVC()
        let activeArray = isSearching ? filteredResults : results // must do this because other wise the data we pass will not correspond to what we select
        destVC.title = activeArray[indexPath.row].name?.capitalized
        destVC.name = activeArray[indexPath.row].name! // passing the data between screens
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}

extension ViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredResults = results.filter({ ($0.name?.lowercased().contains(filter.lowercased()))! }) // basically filtering the results comparing what we type to the names saved in the results 
        
        updateData(on: filteredResults)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: results)
    }
}
