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
              let width = geometry.size.width / CGFloat(lineCount) - 4.0
              ScrollView {
                  LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: width, maximum: width)), count: lineCount), alignment: .center, spacing: 4.0) {
                      ForEach(0..<self.music.viewCollections.count) { index in
                          ArtworkView(collection: self.music.viewCollections[index])
                      }
                  }
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
        if let artwork = self.music.artwork(item: collection.representativeItem!) {
            Image(uiImage: artwork)
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .clipShape(Circle())
                .onTapGesture {
                    self.music.play(collection: self.collection)
                }
                .onLongPressGesture(perform: {
                    self.isShowingPopover.toggle()
                })
                .popover(isPresented: $isShowingPopover) {
                    PopoverView()
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

struct PopoverView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Popover Content")
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            },
                   label: {
                Text("Close")
            })
        }
        .padding()
    }
}
