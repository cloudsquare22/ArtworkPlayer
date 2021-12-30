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
            FirstViewMessage()
                .padding(8.0)
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
        .padding(32.0)
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}

struct FirstViewMessage: View {

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("The app uses the music library.")
                Text("If you don't see the artwork, check to see if it is visible in the Music app.")
            }
            .foregroundColor(.red)
            HStack {
                Spacer()
                Button(action: {
                    UIApplication.shared.open(URL(string: "music:")!, options: [:])
                }, label: {
                    Text("Launch the music app")
                })
                    .buttonStyle(.borderedProminent)
                Spacer()
            }
        }
    }
}
