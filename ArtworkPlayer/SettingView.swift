//
//  SettingView.swift
//  ArtworkPlayer
//
//  Created by Shin Inaba on 2021/12/08.
//

import SwiftUI
import ViewScrapbook

struct SettingView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        NavigationView {
            Form {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                AboutView()
            }
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

struct FilterSettingView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        Section(header: Label("Album Shuffle", systemImage: "opticaldisc")) {
//            NumberPlusMinusInputView(title: NSLocalizedString("Select min tracks", comment: ""), bounds: 1...100, number: self.$music.minTracks)
        }
    }
}

struct AboutView: View {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

    var body: some View {
        Section(header: Text("About")) {
            VStack() {
                HStack {
                    Spacer()
                    Text("Artwork Player")
                        .font(.largeTitle)
//                        .font(Font.custom("HiraMinProN-W6", size: 32))
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Version \(version)")
                    Spacer()
                }
                HStack {
                    Spacer()
                    Image("cloudsquare")
                    Text("©️ 2021 cloudsquare.jp")
                        .font(.footnote)
                    Spacer()
                }
            }
        }
    }
}
