//
//  File.swift
//  ArtworkPlayer
//
//  Created by Shin Inaba on 2021/12/07.
//

import SwiftUI
import MediaPlayer
import Algorithms

final class Music: ObservableObject {
    var player: MPMusicPlayerController! = MPMusicPlayerController.systemMusicPlayer
    @Published var viewCollections: [MPMediaItemCollection] = []
    
    init() {
        self.albums()
    }

    func albums() {
        self.viewCollections = []
        let mPMediaQuery = MPMediaQuery.albums()
        if let collections = mPMediaQuery.collections {
            print(collections.count)
            for index in 0..<76 {
                self.viewCollections.append(collections[index])
            }
        }
        self.viewCollections = self.viewCollections.randomSample(count: self.viewCollections.count)
        print(self.viewCollections.count)
    }
    
    func artwork(item: MPMediaItem) -> UIImage? {
        var result: UIImage? = nil
        if let value = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
            result = value.image(at: CGSize(width: value.bounds.width, height: value.bounds.height))
        }
        print("\(item.albumTitle!):\(result)")
        return result
    }
    
    func albumInformation(item: MPMediaItem) -> (String, String) {
        var result = ("", "")
        if let albumTitle = item.albumTitle {
            result.0 = albumTitle
        }

        if let albumArtist = item.albumArtist {
            result.1 = albumArtist
        }
        else if let artist = item.artist {
            result.1 = artist
        }

        return result
    }
    
    func play(collection: MPMediaItemCollection) {
        self.player.setQueue(with: collection)
        self.player.play()
    }

}
