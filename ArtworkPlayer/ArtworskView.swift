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
    @State var isShowingSettingView = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                let columnCount = Int(geometry.size.width / self.music.artworkSize)
                let width = geometry.size.width / CGFloat(columnCount)
                let columns: [GridItem] = Array(repeating: .init(.fixed(width), spacing: 0.0, alignment: .center), count: columnCount)
//                let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: width - (width / 2), maximum: width + (width / 2)), spacing: 0.0, alignment: .center), count: columnCount + 1)
//                LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: width, maximum: width)), count: columnCount), alignment: .center, spacing: 0.0) {
                LazyVGrid(columns: columns, alignment: .center, spacing: 2.0) {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: self.music.artworkSize, height: self.music.artworkSize, alignment: .center)
                        .clipShape(Circle())
                        .onTapGesture {
                            self.isShowingSettingView.toggle()
                            
                        }
                        .sheet(isPresented: self.$isShowingSettingView, onDismiss: {}, content: {
                            SettingView()
                        })
                    ForEach(0..<self.music.viewCollections.count, id: \.self) { index in
                        ArtworkView(collection: self.music.viewCollections[index])
                    }
                    if self.music.dispOperationArtwork == true {
                        VStack(spacing: 8.0) {
                            Button(action: {
                                self.music.playPause()
                            }
                                   , label: {
                                Image(systemName: "playpause")
                            })
                            VStack {
                                HStack {
                                    Button(action: {
                                        self.music.playPrevious()
                                    }
                                           , label: {
                                        Image(systemName: "backward")
                                    })
                                    Button(action: {
                                        self.music.playNext()
                                    }
                                           , label: {
                                        Image(systemName: "forward")
                                    })
                                }
                            }
                        }
                        .font(self.music.artworkSizeLarge == true ? .largeTitle : .title)
                        .foregroundColor(.primary)
                        .frame(width: self.music.artworkSize - 4, height: self.music.artworkSize - 4, alignment: .center)
                        .overlay(content: {
                            Circle().stroke(lineWidth: 2.0)
                        })
//                        .clipShape(Circle())
                    }
                    Image(systemName: "arrow.clockwise.circle")
                        .resizable()
                        .frame(width: self.music.artworkSize - 4, height: self.music.artworkSize - 4, alignment: .center)
                        .clipShape(Circle())
                        .onTapGesture {
                            self.music.albums()                            
                        }
                }
                Spacer()
            }
        }
        .background(self.music.toColor(selct: self.music.backgroundColor))
//        .onAppear() {
//            self.music.onManual = true
//            self.isShowingSettingView = true
//        }
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
        let artwork = self.music.artwork(item: collection.representativeItem!)
        if self.music.circleShape == true {
            artwork
                .resizable()
                .scaledToFit()
                .frame(width: self.music.artworkSize - 2, height: self.music.artworkSize - 2, alignment: .center)
                .clipShape(Circle())
                .onTapGesture(count: 2) {
                    self.music.play(collection: self.collection, shuffle: self.music.shufflePlay)
                }
                .onTapGesture {
                    self.isShowingPopover.toggle()
                }
                .popover(isPresented: $isShowingPopover) {
                    AlbumInformationView(collection: self.collection)
                }
        }
        else {
            artwork
                .resizable()
                .scaledToFit()
                .frame(width: self.music.artworkSize - 2, height: self.music.artworkSize - 2, alignment: .center)
                .onTapGesture(count: 2) {
                    self.music.play(collection: self.collection, shuffle: self.music.shufflePlay)
                }
                .onTapGesture {
                    self.isShowingPopover.toggle()
                }
                .popover(isPresented: $isShowingPopover) {
                    AlbumInformationView(collection: self.collection)
                }

        }
    }
}

struct AlbumInformationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var music: Music
    var collection: MPMediaItemCollection

    var body: some View {
        let item = self.collection.representativeItem!
        let information = self.music.albumInformation(item: item)
        VStack(alignment: .leading, spacing: 4.0) {
//            HStack {
//                Spacer()
//                Button(action: {
//                    self.presentationMode.wrappedValue.dismiss()
//                },
//                       label: {
//                    Image(systemName: "xmark.circle")
//                })
//                Spacer()
//            }
            Label(information.0, systemImage: "opticaldisc")
            Label(information.1, systemImage: "person")
            HStack {
                Spacer()
                let artwork = self.music.artwork(item: item)
                artwork
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300, alignment: .center)
                Spacer()
            }
            .padding(4)
            HStack {
                Button(action: {
                    self.music.play(collection: self.collection, shuffle: false)
                },
                       label: {
                    Label("All play", systemImage: "play.circle")
                    Spacer()
                })
                    .buttonStyle(.bordered)
                Button(action: {
                    self.music.play(collection: self.collection, shuffle: true)
                },
                       label: {
                    Label("Shuffle play", systemImage: "shuffle.circle")
                    Spacer()
                })
                    .buttonStyle(.bordered)
            }
            .padding(2)
            ScrollView {
                ForEach(0..<self.collection.items.count, id: \.self) { index in
                    HStack {
                        Button(action: {
                            self.music.play(collection: MPMediaItemCollection(items: [self.collection.items[index]]), shuffle: false)
                        }, label: {
                            Label(self.collection.items[index].title!, systemImage: "music.note")
                            Spacer()
                        })
                            .buttonStyle(.bordered)
//                        Image(systemName: "music.note")
//                        Text("\(self.collection.items[index].title!)")
                    }
                }
            }
            .padding(2)
        }
        .padding(16.0)
    }
}
