//
//  SettingView.swift
//  ArtworkPlayer
//
//  Created by Shin Inaba on 2021/12/08.
//

import SwiftUI
import XYZSwiftUIParts

struct SettingView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        NavigationView {
            Form {
                FirstViewMessage()
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
            NavigationLink(destination: {
                ManualView()
            },
                           label: {
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
            Toggle(isOn: self.$music.autoLock, label: {
                Text("Auto Lock")
            })
                .onChange(of: self.music.autoLock) {newValue in
                    self.music.save()
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
                    self.music.setPlaylistList()
                    self.music.save()
                    NotificationCenter.default.post(name: .changeArtwork, object: nil)
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
            Picker(selection: self.$music.selectLibrary, content: {
                Label("Music Library", systemImage: "opticaldisc")
                    .tag(UInt64(0))
                ForEach(0..<self.music.playlistList.count, id: \.self) { index in
                    Label(self.music.playlistList[index].1, systemImage: "ipod")
                        .tag(self.music.playlistList[index].0)
                }
            }, label: {
                Text("Library")
            })
            .pickerStyle(.menu)
            .onChange(of: self.music.selectLibrary, perform: { newvalue in
                self.music.matchSelectLibrary(selectLibrary: self.music.selectLibrary)
                self.music.save()
                NotificationCenter.default.post(name: .changeArtwork, object: nil)
            })
//            Toggle(isOn: self.$music.useSmartPlaylist, label: {
//                Text("Use Smart Playlist")
//            })
//                .onChange(of: self.music.useSmartPlaylist) {newValue in
//                    self.music.save()
//                    self.music.setPlaylistList()
//                    self.music.matchSelectLibrary(selectLibrary: self.music.selectLibrary)
//                }
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
            HStack {
                Text("Background Color")
                Picker(selection: self.$music.backgroundColor, content: {
                    ForEach(0..<Music.SETTINGCOLOR.count, id: \.self) { index in
                        Label(NSLocalizedString(self.music.toColorTitle(selct: index), comment: ""), systemImage: "paintpalette.fill")
                            .foregroundColor(self.music.toColor(selct: index))
                            .tag(index)
                    }
                }, label: {
                    Text("Background Color")
                })
                .labelsHidden()
                .pickerStyle(.wheel)
                .onChange(of: self.music.backgroundColor) {newValue in
                    self.music.save()
                }
            }
            Toggle(isOn: self.$music.circleShape, label: {
                Text("Artwork of circle shape")
            })
                .onChange(of: self.music.circleShape) {newValue in
                    self.music.save()
                }
            Toggle(isOn: self.$music.noartwotkTitle, label: {
                Text("Title display when no artwork")
            })
                .onChange(of: self.music.noartwotkTitle) {newValue in
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
                    Text("©️ 2022-2023 cloudsquare.jp")
                        .font(.footnote)
                    Spacer()
                }
            }
        }
    }
}
