//
//  ViewController.swift
//  AppleMusicDemo
//
//  Created by Nitin on 9/7/23.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyListView: UIStackView!
    
    // MARK: - UI Items
    
    let searchController = UISearchController()
    let loadingIndicator = UIActivityIndicatorView()
    
    // MARK: - Properties
    
    // shared instance for AppleMusicManager class
    let musicManager = AppleMusicManager.shared
    
    var searchViewIsActive: Bool = false {
        didSet {
            print("\(searchViewIsActive)")
            if searchViewIsActive {
                emptyListView.isHidden = true
                tableView.isHidden = false
                tableViewMusicList = []
                tableView.reloadData()
            } else {
                tableViewMusicList = musicList
                tableView.reloadData()
                tableView.isHidden = musicList.isEmpty
                emptyListView.isHidden = !musicList.isEmpty
            }
        }
    }
    
    // array containing user's saved music files
    var musicList: [MusicItemModel] {
        
        var list: [MusicItemModel] = []
        
        if let savedData = UserDefaults.standard.object(forKey: "Music.List") as? [Data] {
            for data in savedData {
                if let jsonData = try? JSONDecoder().decode(MusicItemModel.self, from: data) {
                    list.append(jsonData)
                }
            }
        }
        
        return list
    }
    
    // array which is used to show data in table view
    var tableViewMusicList: [MusicItemModel] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set search bar and table view
        initSearchBar()
        initTableView()
        
        // set activity indicator in view
        setActivityIndicator()
        
        // show hide view based on the music list array count
        tableView.isHidden = musicList.isEmpty
        emptyListView.isHidden = !musicList.isEmpty
        
        tableViewMusicList = musicList
    }
    
    // MARK: - Methods
    
    /// Method to call fetchMusic to get music data based on query
    /// - Parameter query: string value for search term
    func getMusic(query: String) {
        // empty current list and reload table view
        tableView.reloadData()
        
        loadingIndicator.startAnimating()
        
        // call fetch music to get data
        musicManager.fetchMusic(query: query) { value in
            
            let set1:Set<MusicItemModel> = Set(self.musicList)
            let set2:Set<MusicItemModel> = Set(value)
            self.tableViewMusicList = Array(set2.symmetricDifference(set1))
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    /// method to set activity indicator in subview
    func setActivityIndicator() {
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
    }
    
   
}

