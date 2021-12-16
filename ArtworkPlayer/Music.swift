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
    @Published var artworkSizeLarge = false
    @Published var backgroundColor: Int = 0
    @Published var circleShape = true
    
    static let ARTWORKSIZE_SMALL: CGFloat = 120
    static let ARTWORKSIZE_LARGE: CGFloat = 180
    
    var viewCount:  Int  {
        let columnCount = Int(UIScreen.main.bounds.width / self.artworkSize)
        let lineCount = Int(UIScreen.main.bounds.height / self.artworkSize)
        return columnCount * lineCount
    }
    let userdefault = UserDefaults.standard
    var artworkSize: CGFloat {
        self.artworkSizeLarge == true ? Music.ARTWORKSIZE_LARGE : Music.ARTWORKSIZE_SMALL
    }

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
        if let artworkSizeLarge = userdefault.object(forKey: "artworkSizeLarge") as? Bool {
            self.artworkSizeLarge = artworkSizeLarge
        }
        if let backgroundColor = userdefault.object(forKey: "backgroundColor") as? Int {
            self.backgroundColor = backgroundColor
        }
    }
    
    func save() {
        self.userdefault.set(self.iCloud, forKey: "iCloud")
        self.userdefault.set(self.shufflePlay, forKey: "shufflePlay")
        self.userdefault.set(self.minTracks, forKey: "minTracks")
        self.userdefault.set(self.artworkSizeLarge, forKey: "artworkSizeLarge")
        self.userdefault.set(self.backgroundColor, forKey: "backgroundColor")
    }

    func albums() {
        print(UIScreen.main.bounds.size)
                
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

            var loopTo = self.viewCount
            if randomcollections.count < self.viewCount {
                loopTo = randomcollections.count
            }
            if loopTo == self.viewCount {
                loopTo = loopTo - 2
            }
            else if(loopTo == self.viewCount - 1) {
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
        if let value = item.artwork {
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
    
    func printMPMediaItemCollection(collection: MPMediaItemCollection) {
        for item in collection.items {
            print(item.title!)
        }
    }
    
    func play(collection: MPMediaItemCollection, shuffle: Bool) {
        self.player.setQueue(with: collection)
        if shuffle == true {
            self.player.shuffleMode = .songs
        }
        self.player.play()
    }
    
    static let SETTINGCOLOR: [(Color, Color)] = [(.white, .black),
                                                 (.blue, .blue),
                                                 (.brown, .brown),
                                                 (.cyan, .cyan),
                                                 (.gray, .gray),
                                                 (.green, .green),
                                                 (.indigo, .indigo),
                                                 (.mint, .mint),
                                                 (.orange, .orange),
                                                 (.pink, .pink),
                                                 (.purple, .purple),
                                                 (.red, .red),
                                                 (.teal, .teal),
                                                 (.yellow, .yellow)]
    
    func toColor(selct: Int) -> Color {
        UITraitCollection.current.userInterfaceStyle == .light ? Music.SETTINGCOLOR[selct].0 : Music.SETTINGCOLOR[selct].1
    }
}
