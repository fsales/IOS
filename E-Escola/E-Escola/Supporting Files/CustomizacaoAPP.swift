//
//  CustomizacaoAPP.swift
//  E-Escola
//
//  Created by Fábio Sales on 19/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit

struct CustomizacaoAPP{
    
    static let colorBlue: UIColor = UIColor(hexString: "#0066CC")
    static let colorWhite: UIColor = UIColor.white
    
    static func aparencia() {
        customizarTabBar()
        customizarTabBarItem()
        customizarNavigationBar()
        customizarBarButtonItem()
    }
    
    static private func customizarTabBar(){
        let tab = UITabBar.appearance()
        tab.barTintColor = colorBlue.withAlphaComponent(0.6)
        tab.tintColor = colorWhite.withAlphaComponent(0.9)
        tab.unselectedItemTintColor = UIColor.lightGray
        tab.isTranslucent = false
    }
    
    static private func customizarTabBarItem(){
        let tabItem = UITabBarItem.appearance()
        tabItem.badgeColor = colorBlue
        tabItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.vertrina(ofSize: 12)], for: .normal)
        tabItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.vertrina(ofSize: 12)], for: .selected)
        tabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        tabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
    }
    
    static private func customizarNavigationBar(){
        let nav = UINavigationBar.appearance()
        nav.barTintColor = colorBlue
        nav.tintColor = colorWhite
        nav.prefersLargeTitles = true
        nav.titleTextAttributes = [NSAttributedStringKey.font:UIFont.vertrina(ofSize: 17), NSAttributedStringKey.foregroundColor:UIColor.white]
        
        if #available(iOS 11.0, *) {
            nav.prefersLargeTitles = true
            nav.largeTitleTextAttributes = [NSAttributedStringKey.font:UIFont.vertrina(ofSize: 40), NSAttributedStringKey.foregroundColor:UIColor.white]
        }
    }
    
    static private func customizarBarButtonItem(){
        let item = UIBarButtonItem.appearance()
        item.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.vertrina(ofSize: 25)], for: .normal)
    }
    
}
