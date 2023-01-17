//
//  Endpoint.swift
//  Template 2023
//
//  Created by Augusto C.P. on 11/1/23.
//

import Foundation

enum HTTPMethod: String {
    case put = "put"
    case post = "post"
    case get = "get"
    case delete = "delete"
}

enum CachePolicy {
    case returnCacheDataElseFetch
    case fetchIgnoringCacheData
    case fetchIgnoringCacheCompletely
    case returnCacheDataDontFetch
    case returnCacheDataAndFetch
}

protocol EndpointRepresentable {
    var pathName: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any] { get }
}

struct ResponseList<T>: Decodable where T: Decodable {
    let info: Info
    let results: [T]
}

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

extension Info {

    var nextPageIndex: Int? {
        guard let strNextPage = self.next?.urlParameterValue(paramName: "page") else {
            return nil
        }
        return Int(strNextPage)
    }
}
