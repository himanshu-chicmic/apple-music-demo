//
//  ViewController.swift
//  AppleMusicDemo
//
//  Created by Nitin on 9/7/23.
//

import UIKit
import StoreKit
import MusicKit

class ViewController: UIViewController, SKCloudServiceSetupViewControllerDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - UI Items
    
    let searchController = UISearchController()
    let loadingIndicator = UIActivityIndicatorView()
    
    // MARK: - Properties
    
    // shared instance for AppleMusicManager class
    let musicManager = AppleMusicManager.shared
    
    // array which is used to show data in table view
    var tableViewMusicList: MusicItemCollection<Album> = [] {
        didSet {
            tableView.isHidden = tableViewMusicList.isEmpty
            tableView.reloadData()
        }
    }
    
    var collectionViewList: MusicItemCollection<Playlist> = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show apple music signup
        showAppleMusicSignup()
        
        // set search bar and table view
        initSearchBar()
        
        // set activity indicator in view
        setActivityIndicator()
        
        loadingIndicator.startAnimating()
        self.musicManager.fetchMusicPlaylists { value in
            DispatchQueue.main.async {
                self.collectionViewList = value
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    /// Method to show user a view with subscription details
    func showAppleMusicSignup() {
        // cloud service controller instance for checking capabilities
        let controller = SKCloudServiceController()

        // check capabilities
        controller.requestCapabilities { capabilities, error in
            // music can be played
            // user has apple music account
            if capabilities.contains(.musicCatalogPlayback) {
                // Write code here
            }
            // user is eligible to subscribe to apple music
            else if capabilities.contains(.musicCatalogSubscriptionEligible) {
                let vc = SKCloudServiceSetupViewController()
                vc.delegate = self
                let options: [SKCloudServiceSetupOptionsKey: Any] = [
                    .action: SKCloudServiceSetupAction.subscribe,
                    .messageIdentifier: SKCloudServiceSetupMessageIdentifier.playMusic
                ]
                // present view contoroller for subscription offer
                vc.load(options: options) { success, error in
                    if success {
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: - Methods
    
    /// Method to call fetchMusic to get music data based on query
    /// - Parameter query: string value for search term
    func getMusic(query: String) {
        // empty current list and reload table view
        tableView.reloadData()
        
        loadingIndicator.startAnimating()
        
        // call fetch music to get data
        musicManager.fetchMusicAlbum(query: query) { value in
            DispatchQueue.main.async {
                self.tableViewMusicList = value
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

