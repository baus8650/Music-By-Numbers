//
//  Set.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/23/22.
//

import Foundation

struct userSet: Decodable {
    var userSet: [Int]
    var normalForm: [Int]
    var set: PCSet
}

struct ListSets: Decodable {
    var pcSets: [PCSet]
}

struct PCSet: Decodable {
    var cardinality: Int
    var primeForm: [Int]
    var forteNumber: String
    var intervalVector: String
}
