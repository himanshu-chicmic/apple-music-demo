//
//  AppleMusicManager.swift
//  AppleMusicDemo
//
//  Created by Himanshu on 9/7/23.
//

import Foundation
import MusicKit
import StoreKit

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
    
    /// Method to fetch album tracks
    /// - Parameters:
    ///   - album: album instance whose tracks are fetched
    ///   - completion: completion sends a collection of type MusicItemCollection<Track>
    func fetchTracks(album: MusicItemCollection<Album>.Element?, playlist: MusicItemCollection<Playlist>.Element?, completion: @escaping (MusicItemCollection<Track>) -> Void) {
        Task {
            do {
                if let album {
                    let detailed = try await album.with([.tracks])
                    // call completion
                    guard let tracks = detailed.tracks else {
                        completion([])
                        return
                    }
                    completion(tracks)
                } else if let playlist {
                    let detailed = try await playlist.with([.tracks])
                    // call completion
                    guard let tracks = detailed.tracks else {
                        completion([])
                        return
                    }
                    completion(tracks)
                } else {
                    completion([])
                }
            } catch {
                print("Request Error: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func fetchMusicPlaylists(completion: @escaping (MusicItemCollection<Playlist>) -> Void) {
        Task {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    let request = MusicCatalogChartsRequest(kinds: [.mostPlayed], types: [Album.self, Song.self, Playlist.self])
                    let result = try await request.response()
                    
                    guard let playlist = result.playlistCharts.first?.items else {
                        completion([])
                        return
                    }
                    
                    completion(playlist)
                } catch {
                    print("Request Error: \(error.localizedDescription)")
                    completion([])
                }
            default:
                completion([])
                break
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
                    let albums = result.albums
                    // call completion
                    completion(albums)
                } catch {
                    print("Request Error: \(error.localizedDescription)")
                    completion([])
                }
            // permission not granted
            default:
                // call completion with empty array of MusicItemModel
                completion([])
                break
            }
        }
    }
    
    /// Method to show user a view with subscription details
    func checkAppleMusicSubscription(completion: @escaping (AppleMusicSubscription) -> Void) {
        // cloud service controller instance for checking capabilities
        let controller = SKCloudServiceController()

        // check capabilities
        controller.requestCapabilities { capabilities, error in
            // music can be played
            // user has apple music account
            if capabilities.contains(.musicCatalogPlayback) {
                completion(.canPlayMusic) // an play music
            }
            // user is eligible to subscribe to apple music
            else if capabilities.contains(.musicCatalogSubscriptionEligible) {
                completion(.canSubscribeToMusic) // present user with subscription offer
            }
            // handle other cases
            completion(.unknown)
        }
    }
}
