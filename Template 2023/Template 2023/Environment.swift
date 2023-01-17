//
//  Environment.swift
//  Template 2023
//
//  Created by Augusto C.P. on 11/1/23.
//

import Foundation

enum EnvironmentName {
    case dev
    case qa
    case prod
}

protocol EnvironmentRepresentable {
    var baseUrl: String { get }
    var name: EnvironmentName { get }
}

struct Environment: EnvironmentRepresentable {

    static var shared = Environment()

    let baseUrl: String
    let name: EnvironmentName

    private init() {
        baseUrl = "https://rickandmortyapi.com/api"
        name = .dev
    }
}
