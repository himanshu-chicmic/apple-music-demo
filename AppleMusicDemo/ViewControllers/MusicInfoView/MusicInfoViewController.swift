//
//  MusicInfoViewController.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import UIKit

class MusicInfoViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var composerNameLabel: UILabel!
    
    // MARK: - Properties
    var songData: MusicItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.titleView?.tintColor = .white
        
        setDataToView()
    }
    
    func setDataToView() {
        if let data = songData {
            backgroundImageView.image = UIImage(data: data.imageData!)
            titleLabel.text = "\(data.title)"
            albumTitleLabel.text = "\(data.albumTitle ?? "")"
            artistNameLabel.text = "by \(data.artistName)"
            composerNameLabel.text = "\(data.composerName ?? "")"
        }
    }
}
