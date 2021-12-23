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
                ManualSectionView()
                CommonSettingView()
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

struct ManualSectionView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        Section(header: Label("Manual", systemImage: "text.book.closed")) {
            NavigationLink(isActive: self.$music.onManual, destination: {
                ManualView()
            }, label: {
                Text("Manual")
            })
        }
    }
}

struct CommonSettingView: View {
    @EnvironmentObject var music: Music
    
    var body: some View {
        Section(header: Label("Common", systemImage: "gearshape.2")) {
            Toggle(isOn: self.$music.dispOperationArtwork, label: {
                Text("Disp operation artwork")
            })
                .onChange(of: self.music.dispOperationArtwork) {newValue in
                    self.music.save()
                    NotificationCenter.default.post(name: .changeArtwork, object: nil)
                }
        }
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
                    NotificationCenter.default.post(name: .changeArtwork, object: nil)
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
                    NotificationCenter.default.post(name: .changeArtwork, object: nil)
                }
            Picker(selection: self.$music.backgroundColor, content: {
                ForEach(0..<Music.SETTINGCOLOR.count, id: \.self) { index in
                    HStack {
                        Image(systemName: "paintpalette.fill")
                            .foregroundColor(self.music.toColor(selct: index))
                        Text(NSLocalizedString(self.music.toColorTitle(selct: index), comment: ""))
                    }
                    .tag(index)
                }
            }, label: {
                Text("Background Color")
            })
                .onChange(of: self.music.backgroundColor) {newValue in
                    self.music.save()
                }
            Toggle(isOn: self.$music.circleShape, label: {
                Text("Artwork of circle shape")
            })
                .onChange(of: self.music.circleShape) {newValue in
                    self.music.save()
                    NotificationCenter.default.post(name: .changeArtwork, object: nil)
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
