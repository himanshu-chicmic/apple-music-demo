//
//  MusicInfoViewController.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import UIKit
import MusicKit
import StoreKit

class MusicInfoViewController: UIViewController, SKCloudServiceSetupViewControllerDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var albumTitleLable: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var joinAppleMusicBtn: UIButton!
    @IBOutlet weak var playMusicBtn: UIButton!
    
    // MARK: - Properties
    
    // shared instance for AppleMusicManager class
    let musicManager = AppleMusicManager.shared
    
    var album: MusicItemCollection<Album>.Element?
    var playlist: MusicItemCollection<Playlist>.Element?
    var trackList: MusicItemCollection<Track> = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCanPlayMusic()
        
        setDataToView()
        fetchAlbumTracks()
    }
    
    // MARK: - Methods
    
    /// Method to call checkAppleMusicSubscription to get info if the user can play the songs or not
    func checkCanPlayMusic() {
        // show apple music signup
        musicManager.checkAppleMusicSubscription { value in
            switch value {
            case .canPlayMusic:
                // can play music no need to show any subscription
                self.joinAppleMusicBtn.isHidden = true
                self.playMusicBtn.alpha = 1
                self.playMusicBtn.isEnabled = true
                break
            default:
                // handle other cases
                // can play music no need to show any subscription
                self.joinAppleMusicBtn.isHidden = false
                self.playMusicBtn.alpha = 0.75
                self.playMusicBtn.isUserInteractionEnabled = false;
                break
            }
        }
    }
    
    /// Method to fetch album tracks from fetchAlbumTracks
    func fetchAlbumTracks() {
        musicManager.fetchTracks(album: album, playlist: playlist) { value in
            DispatchQueue.main.async {
                self.trackList = value
            }
        }
    }
    
    /// Method to set data in the view
    func setDataToView() {
        if let album {
            assignData(image: album.artwork, title: album.title, artist: album.artistName)
        }
        
        if let playlist {
            assignData(image: playlist.artwork, title: playlist.name, artist: playlist.curatorName ?? "")
        }
    }
    
    func assignData(image: Artwork?, title: String, artist: String) {
        // set image view
        DispatchQueue.global(qos: .userInteractive).async {
            if let image = try? Data(contentsOf: image?.url(width: 1024, height: 1024) ?? URL(string: "https://dummy.com")!) {
                DispatchQueue.main.async {
                    self.backgroundImageView.image = UIImage(data: image)
                }
            }
        }
        // set label values
        albumTitleLable.text = title
        artistNameLabel.text = "by \(artist)"
    }
    
    @IBAction func joinAppleMusicTapped(_ sender: Any) {
        
        // show apple music signup
        musicManager.checkAppleMusicSubscription { value in
            switch value {
            case .canSubscribeToMusic:
                // present user with subscription offer
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
            default:
                break
            }
        }
    }
    
}
