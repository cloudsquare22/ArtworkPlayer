//
//  ManualView.swift
//  ArtworkPlayer
//
//  Created by Shin Inaba on 2021/12/22.
//

import SwiftUI

struct ManualView: View {
    var body: some View {
        List {
            Section(header: Label("Artwork", systemImage: "circle.grid.3x3.fill")) {
                HStack {
                    Label("Tap", systemImage: "hand.tap")
                    Spacer()
                    Text("Display album information")
                }
                HStack {
                    Label("2 Tap", systemImage: "hand.tap")
                    Spacer()
                    Text("Play album")
                }
            }
            Section(header: Label("Control artwork", systemImage: "ipod")) {
                HStack {
                    Image(systemName: "gear")
                    Spacer()
                    Text("Display setting screen")
                }
                HStack {
                    Image(systemName: "arrow.clockwise.circle")
                    Spacer()
                    Text("Artwork update")
                }
                HStack {
                    Image(systemName: "playpause")
                    Image(systemName: "backward")
                    Image(systemName: "forward")
                    Spacer()
                    Text("Play control")
                }
            }
        }
        .navigationTitle("Manual")
    }
}

struct ManualView_Previews: PreviewProvider {
    static var previews: some View {
        ManualView()
    }
}
