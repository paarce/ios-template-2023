//
//  CharacterListEndpoint.swift
//  Template 2023
//
//  Created by Augusto C.P. on 15/1/23.
//

import Foundation

enum CharacterListEndpoint: EndpointRepresentable {

    case fecth(options: Options)

    var pathName: String { "/character" }
    var method: HTTPMethod { .get }
    var params: [String : Any] {
        switch self {
        case .fecth(let options):
            var params: [String: String] = [:]
            if let page = options.page {
                params["page"] = "\(page)"
            }
            if let keywords = options.keywords  {
                params["name"] = keywords
            }
            return params
        }
    }
}

extension CharacterListEndpoint {

    struct Options {
        let page: Int?
        let keywords: String?
    }
}
