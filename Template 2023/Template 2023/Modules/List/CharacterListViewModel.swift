//
//  ListViewModel.swift
//  Template 2023
//
//  Created by Augusto C.P. on 12/1/23.
//

import Foundation

protocol CharacterListViewModelObserver {
    func update(wih content: CharacterListViewModel.Content)
}

class CharacterListViewModel: CharacterListViewModelObserver, ObservableObject {

    enum Content {
        case success([Character])
        case fail(Error)
        case loading
        case empty
    }

    enum State {
        case success([CharacterViewModel])
        case fail(ErrorViewModel)
        case loading
        case empty(EmptyViewModel? = nil)
    }

    @Published private (set) var state: State
    private var searchTask: DispatchWorkItem?
    private var provider: CharacterListProviderReprentable
    var nextPage: Int? {
        provider.nextPage
    }

    init(state: State, provider: CharacterListProviderReprentable) {
        self.state = state
        self.provider = provider
    }

    func initView() {
        provider.observer = self
        guard case .empty = state else { return }
        provider.reload()
    }

    func moveToNextPage() {
        provider.fetchNextPageIfPossible()
    }

    func search(keywords: String) {

        searchTask?.cancel()
        searchTask = nil

        let task = DispatchWorkItem { [weak self] in
            self?.provider.search(keywords: keywords)
        }

        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }

    // MARK: - CharacterListViewModelObserver

    func update(wih content: Content) {

        switch content {
        case .loading:
            self.state = .loading
        case .success(let characters):
            self.state = .success(characters.map({ .init(character: $0) }))
        case .fail(let error):
            self.state = .fail(.init(error: error))
        case .empty:
            self.state = .empty(.init())
        }
    }
}
