//
//  ArtworkView.swift
//  ArtworkPlayer
//
//  Created by Shin Inaba on 2021/12/07.
//

import SwiftUI
import MediaPlayer

struct ArtworskView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        GeometryReader { geometry in
              let lineCount = Int(geometry.size.width / 100)
              let width = geometry.size.width / CGFloat(lineCount)
//              ScrollView {
                  LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: width, maximum: width)), count: lineCount), alignment: .center, spacing: 0.0) {
                      ForEach(0..<self.music.viewCollections.count) { index in
                          ArtworkView(collection: self.music.viewCollections[index])
                      }
                      Image(systemName: "gear")
                          .resizable()
                          .frame(width: 98, height: 98, alignment: .center)
                          .clipShape(Circle())
                          .onTapGesture {
                          }
                      Image(systemName: "shuffle.circle")
                          .resizable()
                          .frame(width: 98, height: 98, alignment: .center)
                          .clipShape(Circle())
                          .onTapGesture {
                              self.music.albums()
                          }
                  }
//              }
        }
    }
}

struct ArtworskView_Previews: PreviewProvider {
    static var previews: some View {
        ArtworskView()
    }
}

struct ArtworkView: View {
    @EnvironmentObject var music: Music
    var collection: MPMediaItemCollection
    @State private var isShowingPopover = false
    
    var body: some View {
        if let artwork = self.music.artwork(item: collection.representativeItem!) {
            Image(uiImage: artwork)
                .resizable()
                .scaledToFit()
                .frame(width: 98, height: 98, alignment: .center)
                .clipShape(Circle())
                .onTapGesture {
                    self.music.play(collection: self.collection)
                }
                .onLongPressGesture(perform: {
                    self.isShowingPopover.toggle()
                })
                .popover(isPresented: $isShowingPopover) {
                    AlbumInformationView(item: collection.representativeItem!)
                }
        }
        else {
            Image(systemName: "opticaldisc")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .clipShape(Circle())
                .foregroundColor(.primary)
        }
    }
}

struct AlbumInformationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var music: Music
    var item: MPMediaItem

    var body: some View {
        let information = self.music.albumInformation(item: item)
        VStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            },
                   label: {
                Image(systemName: "xmark.circle")
            })
            Text(information.0)
            Text(information.1)
        }
        .padding(8.0)
    }
}
