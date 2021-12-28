//
//  FirstView.swift
//  ArtworkPlayer
//
//  Created by Shin Inaba on 2021/12/28.
//

import SwiftUI

struct FirstView: View {
    @EnvironmentObject var music: Music
    var body: some View {
        VStack {
            Label("Manual", systemImage: "text.book.closed")
                .font(.largeTitle)
            Image("firstview")
                .resizable()
                .scaledToFit()
            Button {
                self.music.firstManual = false
                self.music.save()
            } label: {
                Text("Start")
                    .font(.largeTitle)
            }

        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
