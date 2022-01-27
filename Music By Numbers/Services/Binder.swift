//
//  Bind.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/26/22.
//

import Foundation

class Binder<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
