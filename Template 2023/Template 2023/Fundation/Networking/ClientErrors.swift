//
//  ClientErrors.swift
//  Template 2023
//
//  Created by Augusto Cordero Perez on 11/1/23.
//

import Foundation

struct ErrorDetail {
    let raw: Error?
    let message: String?

    init(message: String) {
        self.raw = nil
        self.message = message
    }
    init(error: Error) {
        self.raw = error
        self.message = nil
    }
}

enum APIError: LocalizedError {
    case noData
    case parseError(ErrorDetail = .init(message: "There was an error parsing the data."))

    // Fall under 400..499
    case badRequest(ErrorDetail = .init(message: "Invalid request"))
    case unAuthorised(ErrorDetail = .init(message: "Unautorised request, Please login.") )
    case notFound(ErrorDetail = .init(message: "Data not found, Please retry after some time.") )
    case invalidResponse(ErrorDetail = .init(message: "Invalid response. Please retry after some time."))
    case conflictError(ErrorDetail = .init(message: "Already exist.") )

    // 500 & above
    case serverError(ErrorDetail = .init(message: "Services are down, Please retry after some time."))

    // Some unknown Error
    case unknown(ErrorDetail = .init(message: "Some error occured, Please try again."))

    // Some Error
    case some(ErrorDetail = .init(message: "Some error occured, Please try again."))

    public var errorDescription: String? {
        switch self {
        case .noData:
            return "Could not received data from the server. Please retry."
        case .parseError(let detail), .badRequest(let detail),
                .unAuthorised(let detail), .notFound(let detail),
                .invalidResponse(let detail), .conflictError(let detail),
                .serverError(let detail), .unknown(let detail),
                .some(let detail):

            return detail.raw?.localizedDescription ?? detail.message

        }
    }
}

enum ParseError: Error, LocalizedError {
    case invalidValue(keys: [CodingKey], description: String)
    case parserError(reason: String)

    var errorDescription: String? {
        switch self {
        case .invalidValue(let keys, let description):
            let attr = keys.last?.stringValue
            return "[\(attr ?? "unknown attr")]: \(description)"
        case .parserError(let reason):
            return reason
        }
    }
}

enum RequestCrationError: LocalizedError {

    case invalidURL(ErrorDetail = .init(message: "Invalid Url"))
    case parameterEncodingFailed(ErrorDetail = .init(message: "Encoding Failed"))

    public var errorDescription: String? {
        switch self {
        case .invalidURL(let detail), .parameterEncodingFailed(let detail):
            return detail.raw?.localizedDescription ?? detail.message

        }
    }
}
