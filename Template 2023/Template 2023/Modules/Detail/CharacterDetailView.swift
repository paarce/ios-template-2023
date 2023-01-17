//
//  CharacterDetailView.swift
//  Template 2023
//
//  Created by Augusto C.P. on 12/1/23.
//

import SwiftUI

struct CharacterDetailView: View {

    let character: CharacterViewModel

    init(_ character: CharacterViewModel) {
        self.character = character
    }

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: character.imageURL, content: { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .clipped()
                }
            })
            Text(character.name)
            
//            Spacer()
        }
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(EpisodeListView_Previews.characterViewModel)
    }
}
