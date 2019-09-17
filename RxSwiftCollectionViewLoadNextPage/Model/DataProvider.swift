//
//  DataProvider.swift
//  RxSwiftCollectionViewLoadNextPage
//
//  Created by Vincent on 2019/9/17.
//  Copyright © 2019 Vincent. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DataProvider {
    func fetchData() -> Single<[String]> {
        return Single.just(["1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                            "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"])
            .delay(Double.random(min: 0.7, max: 2.4), scheduler: MainScheduler.instance)
    }
    
    
}

extension Double {
    
    static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min

    }
}
