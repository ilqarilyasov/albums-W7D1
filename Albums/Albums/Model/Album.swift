//
//  Album.swift
//  Albums
//
//  Created by Ilgar Ilyasov on 10/8/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

struct Album: Codable, Equatable {
    
    // MARK: - Properties
    
    var artist: String
    var coverArt: [String]
    var genres: [String]
    var id: String
    var name: String
    var songs: [Song]
    
    // MARK: - MODEL Initializer
    
    init(artist: String, coverArt: [String], genres: [String], id: String = UUID().uuidString, name: String, songs: [Song]) {
        self.artist = artist
        self.coverArt = coverArt
        self.genres = genres
        self.id = id
        self.name = name
        self.songs = songs
    }
    
    // MARK: - CodingKey
    
    enum AlbumKeys: String, CodingKey {
        case artist
        case coverArt
        case genres
        case id
        case name
        case songs
        
        enum CoverArtKeys: String, CodingKey {
            case url
        }
    }
    
    // MARK: - Decoding
    
    init(from decoder: Decoder) throws {
        let albumContainer = try decoder.container(keyedBy: AlbumKeys.self)
        let artist = try albumContainer.decode(String.self, forKey: .artist)
        
        // Why it is unkeyed? I think it's keyed container.
        // But when construction like that I couldn't loop through
        var loopCoverArtContainer = try albumContainer.nestedUnkeyedContainer(forKey: .coverArt)
        var coverArt: [String] = []
        while !loopCoverArtContainer.isAtEnd {
            let coverArtContainer = try loopCoverArtContainer.nestedContainer(keyedBy: AlbumKeys.CoverArtKeys.self)
            let aCoverArt = try coverArtContainer.decode(String.self, forKey: .url)
            coverArt.append(aCoverArt)
        }
        
        let genres = try albumContainer.decode([String].self, forKey: .genres)
        let id = try albumContainer.decode(String.self, forKey: .id)
        let name = try albumContainer.decode(String.self, forKey: .name)
        let songs = try albumContainer.decode([Song].self, forKey: .songs)
        
//        let loopSongsContainer = try albumContainer.nestedUnkeyedContainer(forKey: .songs)
//        var songs:[Song] = []
//        while !loopSongsContainer.isAtEnd {
//            let song = try albumContainer.decode(Song.self, forKey: .songs)
//            songs.append(song)
//        }

        self.artist = artist
        self.coverArt = coverArt
        self.genres = genres
        self.id = id
        self.name = name
        self.songs = songs
    }
    
    // MARK: - Encoding
    
    func encode(to encoder: Encoder) throws {
        var albumContainer = encoder.container(keyedBy: AlbumKeys.self)
        try albumContainer.encode(artist, forKey: .artist)
        
        for aConvertArt in coverArt {
            var coverArtContainer = albumContainer.nestedContainer(keyedBy: AlbumKeys.CoverArtKeys.self, forKey: .coverArt)
            try coverArtContainer.encode(aConvertArt, forKey: .url)
        }
        
        for aGenre in genres {
            var genresContainer = albumContainer.nestedUnkeyedContainer(forKey: .genres)
            try genresContainer.encode(aGenre)
        }
        
        try albumContainer.encode(id, forKey: .id)
        try albumContainer.encode(name, forKey: .name)
        
        for song in songs {
            var songsContainer = albumContainer.nestedContainer(keyedBy: AlbumKeys.self, forKey: .songs)
            try songsContainer.encode(song, forKey: .songs)
        }
    }
}

