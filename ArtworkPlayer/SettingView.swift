//
//  SettingView.swift
//  ArtworkPlayer
//
//  Created by Shin Inaba on 2021/12/08.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        NavigationView {
            Form {
                FilterSettingView()
                DispSettingView()
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
        Section(header: Label("Filter", systemImage: "slider.horizontal.3")) {
            Toggle(isOn: self.$music.iCloud, label: {
                Text("Use iCloud")
            })
                .onChange(of: self.music.iCloud) {newValue in
                    self.music.save()
                }
            Toggle(isOn: self.$music.shufflePlay, label: {
                Text("Shuffle Play")
            })
                .onChange(of: self.music.shufflePlay) {newValue in
                    self.music.save()
                }
            NumberPlusMinusInputView(title: NSLocalizedString("Disp min tracks", comment: ""), bounds: 1...100, number: self.$music.minTracks)
                .onChange(of: self.music.minTracks) {newValue in
                    self.music.save()
                }
        }
    }
}

struct DispSettingView: View {
    @EnvironmentObject var music: Music
    @State var color: Color = .secondary

    var body: some View {
        Section(header: Label("Disp", systemImage: "circle.grid.3x3.fill")) {
            Toggle(isOn: self.$music.artworkSizeLarge, label: {
                Text("Large Artwork Size")
            })
                .onChange(of: self.music.artworkSizeLarge) {newValue in
                    self.music.save()
                    self.music.albums()
                }
            Picker(selection: self.$music.backgroundColor, content: {
                Text("Default")
                    .tag(0)
                ForEach(1..<Music.SETTINGCOLOR.count, id: \.self) { index in
                    Image(systemName: "paintpalette.fill")
                        .foregroundColor(Music.SETTINGCOLOR[index].0)
                        .tag(index)
                }
            }, label: {
                Text("Background Color")
            })
                .onChange(of: self.music.backgroundColor) {newValue in
                    self.music.save()
                }
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
