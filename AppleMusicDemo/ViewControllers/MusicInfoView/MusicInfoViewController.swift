//
//  MusicInfoViewController.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import UIKit
import MusicKit

class MusicInfoViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var albumTitleLable: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var tracksCountLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    // shared instance for AppleMusicManager class
    let musicManager = AppleMusicManager.shared
    
    var album: MusicItemCollection<Album>.Element?
    var trackList: MusicItemCollection<Track> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataToView()
        fetchAlbumTracks()
    }
    
    // MARK: - Methods
    
    /// Method to call checkAppleMusicSubscription to get info if the user can play the songs or not
    func checkCanPlayMusic() {
        musicManager.checkAppleMusicSubscription { play in
            if !play {
                print("Disable: \(play)")
            }
            self.fetchAlbumTracks()
        }
    }
    
    /// Method to fetch album tracks from fetchAlbumTracks
    func fetchAlbumTracks() {
        if let album {
            musicManager.fetchAlbumTracks(album: album) { value in
                self.trackList = value
                DispatchQueue.main.async {
                    self.tracksCountLable.text = "\(self.trackList.count) songs"
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    /// Method to set data in the view
    func setDataToView() {
        if let album {
            // set image view
            DispatchQueue.global(qos: .userInteractive).async {
                if let image = try? Data(contentsOf: album.artwork?.url(width: 1080, height: 1080) ?? URL(string: "https://dummy.com")!) {
                    DispatchQueue.main.async {
                        self.backgroundImageView.image = UIImage(data: image)
                    }
                }
            }
            // set label values
            albumTitleLable.text = album.title
            artistNameLabel.text = "by \(album.artistName)"
        }
    }
}
