//
//  TrackTableViewCell.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import UIKit
import MusicKit

class TrackTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    // MARK: - Methods
    
    /// Method to set data in tableViewCell
    /// - Parameter song: MusicItemCollection<Track> instance
    func setData(album: MusicItemCollection<Track>.Element) {
        songNameLabel.text = album.title
        artistNameLabel.text = album.artistName
    }
}
