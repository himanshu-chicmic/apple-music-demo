//
//  SongTableViewCell.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    // MARK: - Properties
    
    private var musicItem: MusicItemModel?
    
    // MARK: - Methods
    
    /// Method to set data in tableViewCell
    /// - Parameter song: MusicItemModel instance
    func setData(song: MusicItemModel) {
        musicItem = song
        artworkImageView.layer.cornerRadius = 4
        if let data = song.imageData {
            artworkImageView.image = UIImage(data: data)
        }
        songNameLabel.text = song.title
        artistNameLabel.text = song.artistName
    }
    
    
    /// Method to update user defaults and save music list
    /// - Parameter delete: bool value to check whether the call's for delete or add
    func updateMusicList(delete: Bool = false) {
        // first get data from user defaults
        if let data = UserDefaults.standard.object(forKey: "Music.List") as? [Data] {
            
            var music = data
            
            // encode selected item
            guard let encoded = try? JSONEncoder().encode(musicItem) else {
                return
            }
            
            // if delete is true then delete the current item from user defaults
            // else add the item in the music list and save the user defaults
            if delete {
                for (index, data) in music.enumerated() where encoded == data {
                    music.remove(at: index)
                }
            } else {
                for data in music where encoded == data {
                    return
                }
                // insert at top position
                music.insert(encoded, at: 0)
            }
            
            // save data to user defaults
            UserDefaults.standard.set(music, forKey: "Music.List")
        } else {
            // encode selected item
            guard let encoded = try? JSONEncoder().encode(musicItem) else {
                return
            }
            
            UserDefaults.standard.set([encoded], forKey: "Music.List")
        }
    }
    
    // MARK: - IBActions
    @IBAction func addToListTapped(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            updateMusicList(delete: true)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            updateMusicList()
        }
    }
}
