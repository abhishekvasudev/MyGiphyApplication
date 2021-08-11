//
//  MGTabBarController.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 05/08/21.
//

import UIKit

class MGTabBarController: UITabBarController {
    
    let dataStore = DataStore()
    let urlSessionProvider = URLSessionProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = MGColorScheme.darkBlue
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .darkGray
    }
}
