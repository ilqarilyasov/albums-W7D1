//
//  Album.swift
//  Albums
//
//  Created by Ilgar Ilyasov on 10/8/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

struct Album: Decodable {
    
    var artist: String
    var coverArt: [String]
    var genres: [String]
    var id: String
    var name: String
    var songs: [Song]
    
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
    
    // DECODING
    init(from decoder: Decoder) throws {
        let albumContainer = try decoder.container(keyedBy: AlbumKeys.self)
        let artist = try albumContainer.decode(String.self, forKey: .artist)
        
        // Why it is unkeyed? I think it's keyed container.
        // But when construction like that I couldn't loop through
        var coverArtContainer = try albumContainer.nestedUnkeyedContainer(forKey: .coverArt)
        var coverArt: [String] = []
        while !coverArtContainer.isAtEnd {
            let subCoverArtContainer = try coverArtContainer.nestedContainer(keyedBy: AlbumKeys.CoverArtKeys.self)
            let subCoverArt = try subCoverArtContainer.decode(String.self, forKey: .url)
            coverArt.append(subCoverArt)
        }
        
        let genres = try albumContainer.decode([String].self, forKey: .genres)
        let id = try albumContainer.decode(String.self, forKey: .id)
        let name = try albumContainer.decode(String.self, forKey: .name)
        let songs = try albumContainer.decode([Song].self, forKey: .songs)

        self.artist = artist
        self.coverArt = coverArt
        self.genres = genres
        self.id = id
        self.name = name
        self.songs = songs
    }
}
