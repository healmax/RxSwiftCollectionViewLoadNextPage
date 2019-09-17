//
//  WSKLenses.swift
//  WSK
//
//  Created by Vincent on 2019/9/16.
//  Copyright © 2019 Vincent. All rights reserved.
//

import Foundation

protocol Mutable {
}

extension Mutable {
    func mutateOne<T>(transform: (inout Self) -> T) -> Self {
        var newSelf = self
        _ = transform(&newSelf)
        return newSelf
    }
    
    func mutate(transform: (inout Self) -> Void) -> Self {
        var newSelf = self
        transform(&newSelf)
        return newSelf
    }
    
    func mutate(transform: (inout Self) throws -> Void) rethrows -> Self {
        var newSelf = self
        try transform(&newSelf)
        return newSelf
    }
}
