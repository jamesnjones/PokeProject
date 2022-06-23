//
//  Extensions.swift
//  PokeProject
//
//  Created by James Jones on 20/06/2022.
//

import UIKit

extension UIView {
    // A basic extension to UIView to assist with layout and constraints, i have used this in nearly all my UIKit projects. 
    public var width : CGFloat {
        return frame.size.width
    }
    public var height : CGFloat {
        return frame.size.height
    }
    public var top : CGFloat {
        return frame.origin.y
    }
    public var bottom : CGFloat {
        return frame.origin.y + frame.size.height
    }
    public var left : CGFloat {
        return frame.origin.x
    }
    public var right : CGFloat {
        return frame.origin.x + frame.size.width
    }
}
