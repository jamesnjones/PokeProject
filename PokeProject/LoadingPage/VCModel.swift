//
//  VCModel.swift
//  PokeProject
//
//  Created by james Jones on 13/08/2021.
//

import UIKit

struct VCModel {
    static func createTitle(text: UILabel) {
        let titleText = K.title
        var characterIndex = 0.0
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * characterIndex, repeats: false) { (timer) in     // this will allow each letter to populate one at a time, similar to the classic load screens on the old nintendo gameboys
                text.text?.append(letter)
            }
            characterIndex += 1
        }
    }
}
