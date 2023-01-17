//
//  ListService.swift
//  Template 2023
//
//  Created by Augusto C.P. on 11/1/23.
//

import Foundation
import Combine

protocol CharacterListServiceRepresentable {
    func fecth(
        options: CharacterListEndpoint.Options,
        cachePolicy: CachePolicy,
        completion: @escaping (Result<CharacterList, Error>) -> Void
    )
}

class CharacterListService: CharacterListServiceRepresentable {

    private let client: RequestPerformer
    var anyCancellable: AnyCancellable?

    init(client: RequestPerformer = RestClient()) {
        self.client = client
    }

    func fecth(
        options: CharacterListEndpoint.Options,
        cachePolicy: CachePolicy,
        completion: @escaping (Result<CharacterList, Error>) -> Void
    ) {

        do {
            let request = try Request(endpoint: CharacterListEndpoint.fecth(options: options))
            anyCancellable = client.perform(request: request)
                .sink(receiveCompletion: { result in
                    guard case .failure(let error) = result else { return }
                    completion(.failure(error))
                }, receiveValue: { (episodeList: CharacterList) in
                    completion(.success(episodeList))
                })
        } catch( let error) {
            completion(.failure(error))
        }
    }
}
