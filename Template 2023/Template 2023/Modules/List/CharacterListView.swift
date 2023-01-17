//
//  EpisodeListView.swift
//  Template 2023
//
//  Created by Augusto C.P. on 12/1/23.
//

import SwiftUI

struct CharacterListView: View {

    @ObservedObject private var viewModel: CharacterListViewModel
    @State var searchText: String = ""

    init(state: CharacterListViewModel.State = .empty(), page: Int? = nil) {
        self.viewModel = .init(
            state: state,
            provider: CharacterListProvider(currentPage: page)
        )
    }

    var body: some View {
        VStack {
            switch viewModel.state {
            case .success(let episodes):
                characterList(episodes)
                    .searchable(text: $searchText)
                    .onSubmit(of: .search, {
                        viewModel.search(keywords: searchText)
                    })

            case .loading:
                Text("loading")

            case .fail(let error):
                Text(error.message)
            case .empty:
                Text("empty")
            }

            if let nextPage = viewModel.nextPage {
                Button("Next page (\(nextPage))") {
                    viewModel.moveToNextPage()
                }
            }
        }
        .onAppear {
            viewModel.initView()
        }
    }

    private func characterList(_ characters: [CharacterViewModel]) -> some View {
        List(characters, id: \.id) { character in
            NavigationLink(destination: CharacterDetailView(character)) {
                HStack {
                    AsyncImage(url: character.imageURL, content: { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                        }
                    })
                        .frame(width: 50, height: 50)
                    Text(character.name)
                }
//                .frame(height: 50)
           }
        }
    }
}

struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView(state: successState)
//        CharacterListView(state: successState, page: 1)
//        CharacterListView(state: .loading)
//        CharacterListView(state: .fail(.init(error: APIError.badRequest())))
    }
}

extension EpisodeListView_Previews {

    static let characterViewModel: CharacterViewModel = .init(character: .init(
        id: 1,
        name: "Rick Sanchez",
        status: .alive,
        species: .human,
        type: "",
        gender: .male,
        origin: .init(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
        location: .init(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
        url: "https://rickandmortyapi.com/api/character/1",
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
    ))

    static let successState: CharacterListViewModel.State = .success([characterViewModel])
}
