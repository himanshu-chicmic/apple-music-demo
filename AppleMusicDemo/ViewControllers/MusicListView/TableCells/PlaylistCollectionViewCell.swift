//
//  PlaylistCollectionViewCell.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import UIKit
import MusicKit

class PlaylistCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var playlistTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageOverlay: UIView!
    
    // MARK: - Methods
    
    /// Method to set data in cell
    /// - Parameter song: MusicItemCollection instance
    func setData(playlist: MusicItemCollection<Playlist>.Element) {
        imageOverlay.layer.cornerRadius = 4
        imageView.layer.cornerRadius = 4
        DispatchQueue.global(qos: .userInteractive).async {
            if let image = try? Data(contentsOf: playlist.artwork?.url(width: 124, height: 124) ?? URL(string: "https://dummy.com")!) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: image)
                }
            }
        }
        playlistTitle.text = playlist.name
//        songNameLabel.text = album.title
//        artistNameLabel.text = album.artistName
    }
}
