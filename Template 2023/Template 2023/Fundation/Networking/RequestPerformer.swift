//
//  RequestExecutor.swift
//  Template 2023
//
//  Created by Augusto Cordero Perez on 11/1/23.
//

import Foundation
import Combine

protocol RequestRepresentable {
    var urlRequest: URLRequest { get }
}

struct Request: RequestRepresentable {

    private let headers: [String: String] = [:]
    let urlRequest: URLRequest

    init(environment: EnvironmentRepresentable = Environment.shared, endpoint: EndpointRepresentable) throws {

        guard let baseUrl = URL(string: environment.baseUrl) else { throw RequestCrationError.invalidURL() }
        let completeUrl = baseUrl.appendingPathComponent(endpoint.pathName)
        var urlRequest =  URLRequest(url: completeUrl)
        urlRequest.httpMethod = endpoint.method.rawValue

        headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        switch endpoint.method {
        case .post:
            guard let body = try? JSONSerialization.data(withJSONObject: endpoint.params)
            else { throw RequestCrationError.parameterEncodingFailed(.init(message: "Body format is not valid")) }
            urlRequest.httpBody = body
        case .get:
            guard let params = endpoint.params as? [String: String]
            else { throw RequestCrationError.parameterEncodingFailed(.init(message: "Parameters format is not valid")) }
            urlRequest.url?.append(
                queryItems: params.map({ .init(name: $0, value: $1)})
            )
        default:
            break
        }

        debugPrint("=======================================")
        debugPrint(urlRequest)
        debugPrint("=======================================")
        self.urlRequest = urlRequest
    }
}

protocol RequestPerformer {
    func perform<T, R>(request: T)  -> AnyPublisher<R, Error> where T: RequestRepresentable, R: Decodable
}
