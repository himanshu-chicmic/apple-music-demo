//
//  MusicInfoViewController+TableView.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/11/23.
//

import UIKit

extension MusicInfoViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as? TrackTableViewCell else {
            fatalError("Unable to Dequeue Cell")
        }
        cell.setData(album: trackList[indexPath.row])
        return cell
    }
}
