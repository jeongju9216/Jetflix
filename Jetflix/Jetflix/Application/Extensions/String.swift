//
//  String.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
