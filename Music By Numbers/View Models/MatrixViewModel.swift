//
//  MatrixViewModel.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/26/22.
//

import Foundation






func mod(_ a: Int, _ n: Int) -> Int {
    precondition(n > 0, "modulus must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
}
