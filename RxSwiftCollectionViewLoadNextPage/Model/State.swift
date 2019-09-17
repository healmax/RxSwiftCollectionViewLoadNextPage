//
//  State.swift
//  RxSwiftCollectionViewLoadNextPage
//
//  Created by Vincent on 2019/9/17.
//  Copyright © 2019 Vincent. All rights reserved.
//

import Foundation

import Foundation
import RxSwift
import RxCocoa

enum Command {
    case loadPost(post: [String])
    case loadNextPage
}

struct State {
    
    typealias Feedback = (Driver<State>) -> Signal<Command>
    // control
    var isLoading: Bool
    var nextPage: Int?
    var repositories: [String]
    
    init() {
        isLoading = true
        nextPage = 1
        repositories = [String]()
    }
}

extension State {
    
    var loadPageIndex: Int? {
        return isLoading ? nextPage : nil
    }
    
}

extension State {
    static public func reduce(state: State, command: Command) -> State {
        switch command {
        case .loadPost(let post):
            return state.mutate {
                $0.repositories = $0.repositories + post
                $0.isLoading = false
                
            }
        case .loadNextPage:
            return state.mutate {
                $0.isLoading = true
            }
        }
    }
}

extension State: Mutable {
    
}
