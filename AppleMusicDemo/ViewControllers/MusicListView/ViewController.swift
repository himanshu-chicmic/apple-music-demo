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
    @IBOutlet weak var emptyListView: UIStackView!
    
    // MARK: - UI Items
    
    let searchController = UISearchController()
    let loadingIndicator = UIActivityIndicatorView()
    
    // MARK: - Properties
    
    // shared instance for AppleMusicManager class
    let musicManager = AppleMusicManager.shared
    
    var searchViewIsActive: Bool = false {
        didSet {
            if searchViewIsActive {
                emptyListView.isHidden = true
                tableView.isHidden = false
            } else {
                tableViewMusicList = []
                tableView.isHidden = tableViewMusicList.isEmpty
                emptyListView.isHidden = !tableViewMusicList.isEmpty
            }
        }
    }
    
    // array which is used to show data in table view
    var tableViewMusicList: MusicItemCollection<Album> = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        SKCloudServiceController.requestAuthorization { (status) in
//            switch status {
//            case .authorized:
//                // The user granted permission.
//                // You can now access Apple Music features.
//                self.showAppleMusicSignup()
//            case .denied, .notDetermined, .restricted: break
//                // Handle denied or restricted access.
//            @unknown default:
//                break
//            }
//        }
        // set search bar and table view
        initSearchBar()
        
        // set activity indicator in view
        setActivityIndicator()
        
        // show hide view based on the music list array count
        tableView.isHidden = tableViewMusicList.isEmpty
        emptyListView.isHidden = !tableViewMusicList.isEmpty
    }
    
    /// Method to show user a view with subscription details
    func showAppleMusicSignup() {
        let controller = SKCloudServiceController()

        controller.requestCapabilities { capabilities, error in
            if capabilities.contains(.musicCatalogPlayback) {
                // User has Apple Music account
            }
            else if capabilities.contains(.musicCatalogSubscriptionEligible) {
                let vc = SKCloudServiceSetupViewController()
                vc.delegate = self

                let options: [SKCloudServiceSetupOptionsKey: Any] = [
                    .action: SKCloudServiceSetupAction.subscribe,
                    .messageIdentifier: SKCloudServiceSetupMessageIdentifier.playMusic
                ]

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

