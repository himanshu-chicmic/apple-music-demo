//
//  AlbumTableViewCell.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import UIKit
import MusicKit

class AlbumTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    // MARK: - Methods
    
    /// Method to set data in tableViewCell
    /// - Parameter song: MusicItemCollection instance
    func setData(album: MusicItemCollection<Album>.Element) {
        artworkImageView.layer.cornerRadius = 4
        DispatchQueue.global(qos: .userInteractive).async {
            if let image = try? Data(contentsOf: album.artwork?.url(width: 64, height: 64) ?? URL(string: "https://dummy.com")!) {
                DispatchQueue.main.async {
                    self.artworkImageView.image = UIImage(data: image)
                }
            }
        }
        songNameLabel.text = album.title
        artistNameLabel.text = album.artistName
    }
}
