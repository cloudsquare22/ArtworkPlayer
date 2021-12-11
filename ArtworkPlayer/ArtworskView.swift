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
                let width = geometry.size.width / CGFloat(self.music.columnCount)
                LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: width, maximum: width)), count: self.music.columnCount), alignment: .center, spacing: 0.0) {
                    ForEach(0..<self.music.viewCollections.count, id: \.self) { index in
                        ArtworkView(collection: self.music.viewCollections[index])
                    }
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 120, height: 120, alignment: .center)
                        .clipShape(Circle())
                        .onTapGesture {
                            self.isShowingSettingView.toggle()
                            
                        }
                        .sheet(isPresented: self.$isShowingSettingView, onDismiss: {}, content: {
                            SettingView()
                        })
                    Image(systemName: "arrow.clockwise.circle")
                        .resizable()
                        .frame(width: 118, height: 118, alignment: .center)
                        .clipShape(Circle())
                        .onTapGesture {
                            self.music.albums()                            
                        }
              }
                Spacer()
            }
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
        let artwork = self.music.artwork(item: collection.representativeItem!)
        artwork
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120, alignment: .center)
            .clipShape(Circle())
            .onTapGesture(count: 2) {
                self.music.play(collection: self.collection)
            }
            .onTapGesture {
                self.isShowingPopover.toggle()
//                self.music.play(collection: self.collection)
            }
//            .onLongPressGesture(perform: {
//                self.isShowingPopover.toggle()
//            })
            .popover(isPresented: $isShowingPopover) {
                AlbumInformationView(item: collection.representativeItem!)
            }
    }
}

struct AlbumInformationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var music: Music
    var item: MPMediaItem

    var body: some View {
        let information = self.music.albumInformation(item: item)
        VStack(alignment: .leading, spacing: 4.0) {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                },
                       label: {
                    Image(systemName: "xmark.circle")
                })
                Spacer()
            }
            Label(information.0, systemImage: "opticaldisc")
            Label(information.1, systemImage: "person")
        }
        .padding(16.0)
    }
}
