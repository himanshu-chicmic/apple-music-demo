//
//  ViewController+TableView.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View Configuration
    
    /// Method to initialize table view
    func initTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewMusicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "songItemCell", for: indexPath) as? SongTableViewCell else {
            fatalError("Unable to Dequeue Cell")
        }
        cell.setData(song: tableViewMusicList[indexPath.row])
        cell.favouriteButton.isHidden = !searchViewIsActive
        return cell
    }
}
