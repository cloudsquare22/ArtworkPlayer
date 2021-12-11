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
    @Published var iCloud = false
    @Published var shufflePlay = false
    @Published var minTracks: Int = 6
    
    let userdefault = UserDefaults.standard

    init() {
        self.load()
        self.albums()
    }
    
    func load() {
        if let iCloud = userdefault.object(forKey: "iCloud") as? Bool {
            self.iCloud = iCloud
        }
        if let shufflePlay = userdefault.object(forKey: "shufflePlay") as? Bool {
            self.shufflePlay = shufflePlay
        }
        if let minTracks = userdefault.object(forKey: "minTracks") as? Int {
            self.minTracks = minTracks
        }
    }
    
    func save() {
        self.userdefault.set(self.iCloud, forKey: "iCloud")
        self.userdefault.set(self.shufflePlay, forKey: "shufflePlay")
        self.userdefault.set(self.minTracks, forKey: "minTracks")
    }

    func albums() {
        print(UIScreen.main.bounds.size)
        let columnCount = Int(UIScreen.main.bounds.width / 122)
        let lineCount = Int(UIScreen.main.bounds.height / 122)
        print((columnCount * lineCount))
        let viewCount = columnCount * lineCount
                
        let iCloudFilter = MPMediaPropertyPredicate(value: self.iCloud,
                                                    forProperty: MPMediaItemPropertyIsCloudItem,
                                                    comparisonType: .equalTo)

        self.viewCollections = []
        let mPMediaQuery = MPMediaQuery.albums()
        mPMediaQuery.addFilterPredicate(iCloudFilter)
        if let collections = mPMediaQuery.collections {
            print(collections.count)
            let randomcollections = collections.randomSample(count: collections.count).filter({collection in collection.items.count >= self.minTracks})
            print(randomcollections.count)

            var loopTo = viewCount
            if randomcollections.count < viewCount {
                loopTo = randomcollections.count
            }
            if loopTo == viewCount {
                loopTo = loopTo - 2
            }
            else if(loopTo == viewCount - 1) {
                loopTo = loopTo - 1
            }

            for index in 0..<loopTo {
                self.viewCollections.append(randomcollections[index])
            }
        }
        print(self.viewCollections.count)
    }
    
    func artwork(item: MPMediaItem) -> Image {
        var result: Image = Image(systemName: "opticaldisc")
        if let value = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
            if let image = value.image(at: CGSize(width: value.bounds.width, height: value.bounds.height)) {
                result = Image(uiImage: image)
            }
        }
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
        if self.shufflePlay == true {
            self.player.shuffleMode = .songs
        }
        self.player.play()
    }

}
