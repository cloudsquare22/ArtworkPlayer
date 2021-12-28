//
//  ArtworkPlayerApp.swift
//  ArtworkPlayer
//
//  Created by Shin Inaba on 2021/12/07.
//

import SwiftUI

@main
struct ArtworkPlayerApp: App {
    var music: Music = Music()

    var body: some Scene {
        WindowGroup {
            ArtworskView()
                .environmentObject(self.music)
        }
    }
}
