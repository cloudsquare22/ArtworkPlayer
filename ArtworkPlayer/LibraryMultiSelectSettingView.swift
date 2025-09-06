//
//  LibraryMultiSelectSettingView.swift
//  ArtworkPlayer
//
//  Created by Shin Inaba on 2025/09/06.
//

import Foundation

import SwiftUI

struct LibraryMultiSelectSettingView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        Section(content: {
            NavigationLink(destination: {
                LibraryMultiSelectView()
            }, label: {
                HStack {
                    LibraryLabelView()
                    Text("\(self.music.selectLibrarys.count)")
                    Text("Library")
                }
            })
        },
        header: {
            HStack {
                Label("Library", systemImage: "ipod")
            }
        })
    }
}

struct LibraryMultiSelectView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        List {
            ForEach(self.music.playlists) { playlist in
                HStack {
                    if playlist.id == 0 {
                        Image(systemName: "square.stack")
                    }
                    else {
                        Image(systemName: "music.note.list")
                    }
                    Text(playlist.name)
                    Spacer()
                    if self.music.selectLibrarys.contains(0) == true, playlist.id != 0 {
                        Image(systemName: "square")
                            .font(.title)
                            .foregroundStyle(.gray)
                    }
                    else if self.music.selectLibrarys.contains(playlist.id) == false {
                        Image(systemName: "square")
                            .onTapGesture {
                                if playlist.id == 0 {
                                    self.music.selectLibrarys.removeAll()
                                }
                                if self.music.selectLibrarys.contains(0) == false {
                                    self.music.selectLibrarys.append(playlist.id)
                                }
                                self.music.save()
                                print(self.music.selectLibrarys)
                            }
                            .font(.title)
                    }
                    else {
                        Image(systemName: "checkmark.square")
                            .onTapGesture {
                                let nowSelectLibrarys: [UInt64] = self.music.selectLibrarys
                                self.music.selectLibrarys = nowSelectLibrarys.filter({ value in
                                    value != playlist.id
                                })
                                self.music.save()
                                print(self.music.selectLibrarys)
                            }
                            .font(.title)
                    }
                }
                .foregroundStyle(.primary)
            }
        }
        .navigationTitle("Library")
        .onDisappear() {
            print("LibraryMultiSelectView.\(#function)")
            if self.music.selectLibrarys.count == 0 {
                self.music.selectLibrarys.append(0)
                self.music.save()
            }
        }
    }
}

#Preview {
    LibraryMultiSelectSettingView()
        .environmentObject(Music())
}

struct LibraryLabelView: View {
    @State var onLibraryInformation = false

    var body: some View {
        Text("Library")
        if UIDevice.current.userInterfaceIdiom == .pad {
            Image(systemName: "info.bubble")
                .font(.title2)
                .foregroundStyle(.blue)
                .onTapGesture {
                    self.onLibraryInformation.toggle()
                }
                .popover(isPresented: self.$onLibraryInformation, content: {
                    LibraryInfomationView()
                })
        }
        else {
            Image(systemName: "info.bubble")
                .font(.title2)
                .foregroundStyle(.blue)
                .onTapGesture {
                    self.onLibraryInformation.toggle()
                }
                .sheet(isPresented: self.$onLibraryInformation, content: {
                    LibraryInfomationView()
                    Spacer()
                        .presentationDetents([.height(375.0)])
                })
        }
        Spacer()
    }
}

struct LibraryInfomationView: View {
    var body: some View {
        Label("Library", systemImage: "info.bubble")
            .font(.title)
            .padding(16.0)
        Text("You can choose from the music library and playlists.")
        VStack(alignment: .leading, spacing: 8.0) {
            Label("Music Library", systemImage: "music.note.list")
                .font(.title3)
            Text("All albums are eligible.")
                .padding(.leading, 16.0)
            Label("Playlist", systemImage: "music.note.list")
                .font(.title3)
                .padding(.top, 16.0)
            Text("Albums in the playlist are eligible.")
                .padding(.leading, 16.0)
            Text("The songs in the album are only those registered in the playlist.")
                .padding(.leading, 16.0)
        }
        .padding(16.0)
    }
}
