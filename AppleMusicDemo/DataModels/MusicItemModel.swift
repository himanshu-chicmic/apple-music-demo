//
//  MusicItemModel.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import MusicKit
import Foundation

// MARK: - Music Model
struct MusicItemModel: Identifiable, Hashable, Codable {
    var id: MusicItemID
    let url: URL?
    let title: String
    let artistName: String
    let imageData: Data?
    let duration: TimeInterval?
    
    let genreNames: [String]
    
    let hasLyrics: Bool
    let composerName: String?
    let albumTitle: String?
    let trackNumber: Int?
    let releaseDate: Date?
}
