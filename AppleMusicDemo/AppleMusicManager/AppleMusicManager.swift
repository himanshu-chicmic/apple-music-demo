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
    
    /// Method to check if user can play music
    /// - Parameter completion: boolean value
    func checkAppleMusicSubscription(completion: @escaping (Bool) -> Void) {
        Task {
            // var to store music subscription updates/type
            var musicSubscription: MusicSubscription?
            // observe updates on music subscription
            for await subsciption in MusicSubscription.subscriptionUpdates {
                musicSubscription = subsciption
            }
            // completion
            completion(musicSubscription?.canPlayCatalogContent ?? false)
        }
    }
    
    /// Method to fetch album tracks
    /// - Parameters:
    ///   - album: album instance whose tracks are fetched
    ///   - completion: completion sends a collection of type MusicItemCollection<Track>
    func fetchAlbumTracks(album: MusicItemCollection<Album>.Element, completion: @escaping (MusicItemCollection<Track>) -> Void) {
        Task {
            do {
                let detailedAlbum = try await album.with([.tracks])
                // call completion
                guard let tracks = detailedAlbum.tracks else {
                    completion([])
                    return
                }
                completion(tracks)
            } catch {
                print("Request Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Method to fetch music items based on "query" string
    /// - Parameters:
    ///   - query: a string value for search term
    ///   - completion: escaping closure for sending collection of type MusicItemCollection<Album>
    func fetchMusicAlbum(query: String, completion: @escaping (MusicItemCollection<Album>) -> Void) {
        Task {
            // check status of Music Authorization
            let status = await MusicAuthorization.request()
            switch status {
            // permission is granted
            case .authorized:
                do {
                    // search request for "query" with types to look for (Song, Artist, Album)
                    var request = MusicCatalogSearchRequest(term: query, types: [Album.self])
                    request.includeTopResults = true
                    request.limit = fetchResultLimit
                    // get request's reponse
                    let result = try await request.response()
                    // get song details in [MusicItemModel] array
                    let albums = result.albums
                    // call completion
                    completion(albums)
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
