//
//  ErrorViewModel.swift
//  Template 2023
//
//  Created by Augusto C.P. on 13/1/23.
//

import SwiftUI

struct ErrorViewModel {

    let message: String

    init(error: Error) {
        self.message = error.localizedDescription
    }
}
