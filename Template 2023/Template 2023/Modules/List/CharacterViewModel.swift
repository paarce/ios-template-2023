//
//  CharacterViewModel.swift
//  Template 2023
//
//  Created by Augusto C.P. on 13/1/23.
//

import Foundation

struct CharacterViewModel {

    let id: Int
    let name: String
    let imageURL: URL?
    let episodes: [String]

    init(character: Character) {
        id = character.id
        name = character.name
        imageURL = URL(string: character.image)
        episodes = []
    }
}
