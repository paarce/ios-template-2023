//
//  NavigationMainView.swift
//  Template 2023
//
//  Created by Augusto C.P. on 13/1/23.
//

import SwiftUI

struct NavigationMainView: View {

    var body: some View {

        NavigationView {
            CharacterListView()
        }
    }
}

struct NavigationMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationMainView()
    }
}
