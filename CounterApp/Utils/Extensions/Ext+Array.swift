//
//  Ext+Array.swift
//  CounterApp
//
//  Created by Andres Acevedo on 07.01.2021.
//

import Foundation

extension Array where Element: Hashable {
    func differenceArray(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
