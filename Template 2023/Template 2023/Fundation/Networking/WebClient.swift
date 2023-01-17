//
//  WebClient.swift
//  Template 2023
//
//  Created by Augusto Cordero Perez on 11/1/23.
//

import Foundation
import Combine

struct RestClient: RequestPerformer {

    private let configuration: URLSessionConfiguration
    private let session: URLSession

    init(sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default) {
        configuration = URLSession.shared.configuration
        session = URLSession(configuration: configuration)
    }

    func perform<T, R>(request: T) -> AnyPublisher<R, Error> where T: RequestRepresentable, R: Decodable {
        session.dataTaskPublisher(for: request.urlRequest)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw parseError(data: data, response: response)
                }
                return data

            }
            .decode (type: R.self, decoder: JSONDecoder())
            .mapError({ error -> Error in
                if let error = error as? APIError {
                    return error
                } else if let decoding = error as? DecodingError {
                    if case .dataCorrupted(let context) = decoding {
                        return ParseError.invalidValue(keys: context.codingPath, description: context.debugDescription)
                    } else {
                        return ParseError.parserError(reason: error.localizedDescription)
                    }
                } else {
                    return APIError.unknown()
                }
            })
            .receive(on: RunLoop.main).eraseToAnyPublisher()
    }

    private func parseError(data: Data, response: URLResponse) -> Error {

        if let httpUrlResponse = response as? HTTPURLResponse {

            switch httpUrlResponse.statusCode {
            case 400:
                return APIError.badRequest()
            case 401:
                return APIError.unAuthorised()
            case 404:
                return APIError.notFound()
            case 400...499:
                return APIError.invalidResponse()
            case 500...599:
                return APIError.serverError()
            default:
                return APIError.unknown()
            }
        }
        return APIError.invalidResponse()
    }
}
