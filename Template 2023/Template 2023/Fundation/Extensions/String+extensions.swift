//
//  URLComponents+extensions.swift
//  Template 2023
//
//  Created by Augusto C.P. on 12/1/23.
//

import Foundation


extension String {

    func urlParameterValue(paramName: String) -> String? {
      guard let url = URLComponents(string: self) else { return nil }
      return url.queryItems?.first(where: { $0.name == paramName })?.value
    }
}
