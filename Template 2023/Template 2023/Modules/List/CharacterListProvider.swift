//
//  EpisodeListProvider.swift
//  Template 2023
//
//  Created by Augusto C.P. on 12/1/23.
//

import Foundation

protocol CharacterListProviderReprentable {
    var nextPage: Int? { get }
    var observer: CharacterListViewModelObserver? { get set }

    func reload()
    func fetchNextPageIfPossible()
    func search(keywords: String)
}

class CharacterListProvider: CharacterListProviderReprentable {

    var observer: CharacterListViewModelObserver?
    private (set) var nextPage: Int?
    private let service: CharacterListServiceRepresentable
    private var isLoading = false
    private var keywords: String?
    private var currentPage: Int? {
        let nextPage = (nextPage ?? 0)
        return nextPage > 0 ? nextPage - 1 : nil
    }

    init(
        service: CharacterListServiceRepresentable = CharacterListService(),
        currentPage: Int? = nil
    ) {
        self.service = service
        if let currentPage = currentPage {
            self.nextPage = currentPage + 1
        }
    }

    //MARK: - EpisodeListProviderReprentable

    func fetchNextPageIfPossible() {
        fetch(page: nextPage)
    }

    func reload() {
        fetch(page: currentPage)
    }

    func search(keywords: String) {
        self.keywords = keywords
        fetch(page: nil)
    }

    //MARK: - Private methods

    private func fetch(page: Int?) {
        guard !isLoading else { return }
        isLoading = true
        observer?.update(wih: .loading)

        service.fecth(
            options: .init(page: page, keywords: keywords),
            cachePolicy: .fetchIgnoringCacheData
        ) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.nextPage = response.info.nextPageIndex
                self.observer?.update(wih: .success(response.results))

            case .failure(let error):
                self.observer?.update(wih: .fail(error))
            }
        }
    }
}
