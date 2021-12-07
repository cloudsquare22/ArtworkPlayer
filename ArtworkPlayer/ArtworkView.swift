//
//  ArtworkView.swift
//  ArtworkPlayer
//
//  Created by Shin Inaba on 2021/12/07.
//

import SwiftUI

struct ArtworkView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        GeometryReader { geometry in
              let lineCount = Int(geometry.size.width / 100)
              let width = geometry.size.width / CGFloat(lineCount) - 4.0
              ScrollView {
                  LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: width, maximum: width)), count: lineCount), alignment: .center, spacing: 4.0) {
                      ForEach(0..<self.music.viewCollections.count) { index in
                          if let artwork = self.music.artwork(item: self.music.viewCollections[index].representativeItem!) {
                              Image(uiImage: artwork)
                                  .resizable()
                                  .frame(width: 100, height: 100, alignment: .center)
                                  .clipShape(Circle())
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
              }
        }
    }
}

struct ArtworkView_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkView()
    }
}
