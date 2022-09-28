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
    @Published var minTracks: Int = 1
    @Published var artworkSizeLarge = false
    @Published var backgroundColor: Int = 0
    @Published var circleShape = true
    @Published var dispOperationArtwork = false
    @Published var firstManual = true
    @Published var nowPlayingItem: MPMediaItem? = nil
    @Published var autoLock = true  {
        willSet {
            setIsIdleTimerDisabled(lock: newValue)
        }
    }
    @Published var selectLibrary: UInt64 = 0
    @Published var playlistList: [(UInt64, String)] = []
    @Published var useSmartPlaylist = false
    var nowWidth: CGFloat = 0.0
    var nowHeight: CGFloat = 0.0
    
    static let ARTWORKSIZE_SMALL: CGFloat = 120 - 2
    static let ARTWORKSIZE_LARGE: CGFloat = 180 - 2
    
    var viewCount:  Int  {
        let columnCount = Int(UIScreen.main.bounds.width / self.artworkSize)
        let lineCount = Int((UIScreen.main.bounds.height - 20) / self.artworkSize)
        print("columnCount:\(columnCount),lineCount:\(lineCount), viewCount:\(columnCount * lineCount)")
        return columnCount * lineCount
    }
    let userdefault = UserDefaults.standard
    var artworkSize: CGFloat {
        self.artworkSizeLarge == true ? Music.ARTWORKSIZE_LARGE : Music.ARTWORKSIZE_SMALL
    }

    init() {
        if let nowPlayingItem = self.player.nowPlayingItem  {
            self.nowPlayingItem = nowPlayingItem
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: .MPMusicPlayerControllerNowPlayingItemDidChange, object: self.player, queue: nil, using: { notification in
            print("change item")
            if let nowPlayingItem = self.player.nowPlayingItem  {
                self.nowPlayingItem = nowPlayingItem
            }
        })
        player.beginGeneratingPlaybackNotifications()
        self.load()
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
        if let circleShape = userdefault.object(forKey: "circleShape") as? Bool {
            self.circleShape = circleShape
        }
        if let dispOperationArtwork = userdefault.object(forKey: "dispOperationArtwork") as? Bool {
            self.dispOperationArtwork = dispOperationArtwork
        }
        if let firstManual = userdefault.object(forKey: "firstManual") as? Bool {
            self.firstManual = firstManual
        }
        if let autoLock = userdefault.object(forKey: "autoLock") as? Bool {
            self.autoLock = autoLock
        }
        if let useSmartPlaylist = userdefault.object(forKey: "useSmartPlaylist") as? Bool {
            self.useSmartPlaylist = useSmartPlaylist
        }
        self.setPlaylistList()
        if let selectLibrary = userdefault.object(forKey: "selectLibrary") as? UInt64 {
            self.matchSelectLibrary(selectLibrary: selectLibrary)
        }
    }
    
    func save() {
        self.userdefault.set(self.iCloud, forKey: "iCloud")
        self.userdefault.set(self.shufflePlay, forKey: "shufflePlay")
        self.userdefault.set(self.minTracks, forKey: "minTracks")
        self.userdefault.set(self.artworkSizeLarge, forKey: "artworkSizeLarge")
        self.userdefault.set(self.backgroundColor, forKey: "backgroundColor")
        self.userdefault.set(self.circleShape, forKey: "circleShape")
        self.userdefault.set(self.dispOperationArtwork, forKey: "dispOperationArtwork")
        self.userdefault.set(self.firstManual, forKey: "firstManual")
        self.userdefault.set(self.autoLock, forKey: "autoLock")
        self.userdefault.set(self.selectLibrary, forKey: "selectLibrary")
        self.userdefault.set(self.useSmartPlaylist, forKey: "useSmartPlaylist")
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
            let controlArtworkCount = self.dispOperationArtwork == false ? 2 : 3
            print("viewCount:\(self.viewCount) loopTo:\(loopTo) ontrolArtworkCount:\(controlArtworkCount)")
            if (self.viewCount - loopTo) <= controlArtworkCount {
                loopTo = loopTo - (controlArtworkCount - (self.viewCount - loopTo))
            }
            for index in 0..<loopTo {
                self.viewCollections.append(randomcollections[index])
            }
        }
        print(self.viewCollections.count)
    }
    
    func albums(width: CGFloat, height: CGFloat, forced: Bool = false) {
        print(#function)
        print("Now width:\(self.nowWidth),Now height\(self.nowHeight)")
        print("width:\(width),height\(height)")
        
        if ((self.nowWidth == width && self.nowHeight == height) ||
            (self.nowWidth == height && self.nowHeight == width)) &&
            (forced == false) {
            print("no change")
            return
        }

        self.nowWidth = width
        self.nowHeight = height

        let columnCount = Int(width / self.artworkSize)
        let lineCount = Int((height - 20) / self.artworkSize)
        let viewCount = columnCount * lineCount

        let iCloudFilter = MPMediaPropertyPredicate(value: self.iCloud,
                                                    forProperty: MPMediaItemPropertyIsCloudItem,
                                                    comparisonType: .equalTo)

        self.viewCollections = []
        let mPMediaQuery = MPMediaQuery.albums()
        mPMediaQuery.addFilterPredicate(iCloudFilter)
        var collections: [MPMediaItemCollection]? = []
        if self.selectLibrary == 0 {
            collections = mPMediaQuery.collections
        }
        else {
            collections = self.playList(playlistid: self.selectLibrary)
        }
        
        if let collections = collections, collections.count > 0 {
            print(collections.count)
            let randomcollections = collections.randomSample(count: collections.count).filter({collection in collection.items.count >= self.minTracks})
            print(randomcollections.count)

            var loopTo = viewCount
            if randomcollections.count < viewCount {
                loopTo = randomcollections.count
            }
            let controlArtworkCount = self.dispOperationArtwork == false ? 2 : 3
            print("viewCount:\(viewCount) loopTo:\(loopTo) ontrolArtworkCount:\(controlArtworkCount)")
            if (viewCount - loopTo) <= controlArtworkCount {
                loopTo = loopTo - (controlArtworkCount - (viewCount - loopTo))
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
    
    func artwork(item: MPMediaItem) -> Image? {
        var result: Image? = nil
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
    
    func playPause() {
        if self.player.playbackState == .playing {
            self.player.pause()
        }
        else {
            self.player.play()
        }
    }
    
    func playNext() {
        if self.player.playbackState == .playing {
            self.player.skipToNextItem()
        }
    }
    
    func playPrevious() {
        if self.player.playbackState == .playing {
            self.player.skipToPreviousItem()
        }
    }
    
    static let SETTINGCOLOR: [(Color, Color, String)] = [(.white, .black, "Default"),
                                                         (.blue, .blue, "Blue"),
                                                         (.brown, .brown, "Brown"),
                                                         (.cyan, .cyan, "Cyan"),
                                                         (.gray, .gray, "Gray"),
                                                         (.green, .green, "Green"),
                                                         (.indigo, .indigo, "Indigo"),
                                                         (.mint, .mint, "Mint"),
                                                         (.orange, .orange, "Orange"),
                                                         (.pink, .pink, "Pink"),
                                                         (.purple, .purple, "Purple"),
                                                         (.red, .red , "Red"),
                                                         (.teal, .teal, "Teal"),
                                                         (.yellow, .yellow, "Yellow")]
    
    func toColor(selct: Int) -> Color {
        UITraitCollection.current.userInterfaceStyle == .light ? Music.SETTINGCOLOR[selct].0 : Music.SETTINGCOLOR[selct].1
    }
    
    func toColorTitle(selct: Int) -> String {
        Music.SETTINGCOLOR[selct].2
    }

    func setIsIdleTimerDisabled(lock:Bool) {
        print(lock)
        UIApplication.shared.isIdleTimerDisabled = !lock
        print("autoLock:\(UIApplication.shared.isIdleTimerDisabled)")
    }
    
    func playList(playlistid: UInt64) -> [MPMediaItemCollection] {
        var result: [MPMediaItemCollection] = []
        let iCloudFilter = MPMediaPropertyPredicate(value: true,
                                                    forProperty: MPMediaItemPropertyIsCloudItem,
                                                    comparisonType: .equalTo)
        let idFilter = MPMediaPropertyPredicate(value: playlistid,
                                                forProperty: MPMediaPlaylistPropertyPersistentID,
                                                comparisonType: .equalTo)

        let mPMediaQuery = MPMediaQuery.playlists()
        mPMediaQuery.addFilterPredicate(iCloudFilter)
        mPMediaQuery.addFilterPredicate(idFilter)
        if let collections = mPMediaQuery.collections, collections.count > 0 {
            var maps: [UInt64:MPMediaItemCollection] = [:]
            for item in collections[0].items {
                if self.iCloud == false, item.isCloudItem == true {
                    continue
                }
                print(String(item.albumPersistentID) + ":" + item.albumTitle! + ":" + item.title!)
                if let itemCollection = maps[item.albumPersistentID] {
                    var items = itemCollection.items
                    items.append(item)
                    let itemCollection = MPMediaItemCollection(items: items)
                    maps[item.albumPersistentID] = itemCollection
                }
                else {
                    let itemCollection = MPMediaItemCollection(items: [item])
                    maps[item.albumPersistentID] = itemCollection
                }
            }
            print(maps.count)
            for map in maps {
                result.append(map.value)
            }
        }
        return result
    }
    
    fileprivate func appendPlaylistList(_ collection: MPMediaItemCollection) {
        if let id = collection.value(forProperty: MPMediaPlaylistPropertyPersistentID) as? UInt64,
           let name = collection.value(forProperty: MPMediaPlaylistPropertyName) as? String {
            print("playlist:(\(id), \(name))")
            self.playlistList.append((id, name))
        }
    }
    
    func setPlaylistList() {
        print(#function)
        self.playlistList = []
        let iCloudFilter = MPMediaPropertyPredicate(value: true,
                                                    forProperty: MPMediaItemPropertyIsCloudItem,
                                                    comparisonType: .equalTo)
        let mPMediaQuery = MPMediaQuery.playlists()
        mPMediaQuery.addFilterPredicate(iCloudFilter)
        if let collections = mPMediaQuery.collections {
            for collection in collections {
                print("mediaTypes:\(collection.mediaTypes.rawValue)")
                if (collection.mediaTypes == .music) && (collection.items.count > 0) {
                    appendPlaylistList(collection)
                }
                else if (self.useSmartPlaylist == true) && (collection.mediaTypes.rawValue == 0) && (collection.items.count > 0) {
                    appendPlaylistList(collection)
                }
            }
        }
    }
    
    func matchSelectLibrary(selectLibrary: UInt64) {
        self.selectLibrary = 0
        self.setPlaylistList()
        for playlist in self.playlistList {
            if playlist.0 == selectLibrary {
                self.selectLibrary = selectLibrary
                break
            }
        }
    }
}
