//
//  ViewController+TableView.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewMusicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumTableViewCell else {
            fatalError("Unable to Dequeue Cell")
        }
        cell.setData(album: tableViewMusicList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destinationVC = storyboard?.instantiateViewController(withIdentifier: "AlbumInfo") as? MusicInfoViewController else {
            return
        }
        destinationVC.album = tableViewMusicList[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
