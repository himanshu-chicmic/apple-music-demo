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
    
    private var musicSub: MusicSubscription?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataToView()
        
        fetchAlbumTracks()
    }
    
    func checkCanPlayMusic() {
        musicManager.checkAppleMusicSubscription { play in
            if !play {
                print("Disable: \(play)")
            }
            self.fetchAlbumTracks()
        }
    }
    
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
    
    func setDataToView() {
        if let album {
            DispatchQueue.global(qos: .userInteractive).async {
                if let image = try? Data(contentsOf: album.artwork?.url(width: 1080, height: 1080) ?? URL(string: "https://dummy.com")!) {
                    DispatchQueue.main.async {
                        self.backgroundImageView.image = UIImage(data: image)
                    }
                }
            }
            
            albumTitleLable.text = album.title
            artistNameLabel.text = "by \(album.artistName)"
        }
    }
}
