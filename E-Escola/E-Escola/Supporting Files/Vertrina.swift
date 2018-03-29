//
//  Vertrina.swift
//  FakeApp
//
//  Created by Pedro Henrique on 16/09/17.
//  Copyright © 2017 IESB. All rights reserved.
//

import UIKit

//Para ver as fontes disponíveis. Fontes adicionadas devem ser incluidas no Info.plist
//print(UIFont.familyNames)
//print(UIFont.fontNames(forFamilyName: "Vertrina Condensed"))

extension UIFont {
    class var vertrinaFontName: String {
        get {
            return "VertrinaCondensed-CondensedBold"
        }
    }
    
    class func vertrina(ofSize size: CGFloat) -> UIFont {
        guard let font =  UIFont(name: vertrinaFontName, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
