//
//  SearchViewModel.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    struct Input {
        let searchTrigger: Observable<Void>
        let searchText: Observable<String>
    }
    
    struct Output {
        let test: Observable<Int>
    }
    
    func transform(input: Input) -> Output {
        
        let list = input.searchTrigger.withLatestFrom(input.searchText).map { text in
            print("text \(text)")

        }.flatMap {
            return Observable.just(1)
        }
        return Output(test: list)
    }
}
