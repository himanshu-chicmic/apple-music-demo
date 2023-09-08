//
//  AppleMusicManager.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import Foundation
import MusicKit

class AppleMusicManager {
    
    // MARK: - Properties
    
    // shared instance of AppleMusicManager
    static let shared = AppleMusicManager()
    // property for fetching results limit
    private let fetchResultLimit: Int = 20
    
    // MARK: - Initializer
    
    // default private init
    private init() {}
    
    // MARK: - Methods
    
    /// Method to fetch music items based on "query" string
    /// - Parameters:
    ///   - query: a string value for search term
    ///   - completion: escaping closure for sending an array of type [MusicItemModel]
    func fetchMusic(query: String, completion: @escaping ([MusicItemModel]) -> Void) {
        Task {
            // check status of Music Authorization
            let status = await MusicAuthorization.request()
            switch status {
            // permission is granted
            case .authorized:
                do {
                    // search request for "query" with types to look for (Song, Artist, Album)
                    var request = MusicCatalogSearchRequest(term: query, types: [Song.self, Artist.self, Album.self, MusicVideo.self])
                    
                    request.limit = fetchResultLimit
                    // get request's reponse
                    let result = try await request.response()
                    // get song details in [MusicItemModel] array
                    let songs: [MusicItemModel] = result.songs.compactMap{
                        return .init(
                            id           : $0.id,
                            url          : $0.url,
                            title        : $0.title,
                            artistName   : $0.artistName,
                            imageData    : try? Data(contentsOf: $0.artwork?.url(width: 1080, height: 1080) ?? URL(string: "https://dummy.com")!),
                            duration     : $0.duration,
                            genreNames   : $0.genreNames,
                            hasLyrics    : $0.hasLyrics,
                            composerName : $0.composerName,
                            albumTitle   : $0.albumTitle,
                            trackNumber  : $0.trackNumber,
                            releaseDate  : $0.releaseDate
                        )
                    }
                    // call completion
                    completion(songs)
                } catch {
                    print("Request Error: \(error.localizedDescription)")
                }
            // permission not granted
            default:
                // call completion with empty array of MusicItemModel
                completion([])
                break
            }
        }
    }
}
