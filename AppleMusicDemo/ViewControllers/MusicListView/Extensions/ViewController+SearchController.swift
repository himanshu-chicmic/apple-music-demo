//
//  ViewController+SearchController.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import Foundation
import UIKit

extension ViewController: UISearchBarDelegate {
    
    // MARK: - Search Bar Configuration
    
    /// Method to initialize search bar in navigation item
    func initSearchBar() {
        searchController.searchBar.placeholder = "Search Song, Artist, or Album"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.searchTextField.addTarget(self, action: #selector(filterData), for: .editingDidEnd)
        searchController.searchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        collectionView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableViewMusicList = []
        collectionView.isHidden = false
    }
    
    @objc
    /// Method to call getMusic with query entered in search bar
    func filterData(sender: Any, event: UIControl.Event) {
        if searchController.isActive {
            getMusic(query: searchController.searchBar.text ?? "Hip Hop")
        }
    }
}
