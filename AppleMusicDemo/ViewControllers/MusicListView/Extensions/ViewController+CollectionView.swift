//
//  ViewController+CollectionView.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/12/23.
//

import Foundation
import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playlistItem", for: indexPath) as? PlaylistCollectionViewCell else {
            fatalError("Unable to dequeue")
        }
        
        cell.setData(playlist: collectionViewList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 3) - 8, height: (collectionView.frame.width / 3) - 8)
    }
}
