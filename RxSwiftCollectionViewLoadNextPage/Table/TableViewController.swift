//
//  TableViewController.swift
//  RxSwiftCollectionViewLoadNextPage
//
//  Created by Vincent on 2019/9/17.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFeedback
import RxDataSources

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let provider = DataProvider()
    let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(
        configureCell: { (dataSource, tableView, indexPath, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
    }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        let trigger: State.Feedback = { state in
            return state.flatMapLatest { [unowned self] state in
                guard !state.isLoading else {
                    return Signal.empty()
                }
                
                return self.tableView.rx.willDisplayCell
                    .asSignal()
                    .filter { (cell, indexPath) in
                        return indexPath.row == state.repositories.count - 3
                    }
                    .map { _ in .loadNextPage }
            }
        }
        
        
        let loadPageFeedback: State.Feedback
            = react(request: { state in
                state.loadPageIndex
                
            }) {  [unowned self] pageIndex -> Signal<Command>  in
                return self.provider.fetchData()
                    .asSignal(onErrorJustReturn: [String]())
                    .map(Command.loadPost)
        }
        
        let state = Driver.system(
            initialState: State(),
            reduce: State.reduce,
            feedback: trigger, loadPageFeedback
        )
        
        state
            .map { $0.repositories }
            .map { [SectionModel(model: "Repositories", items: $0)] }
            .debug("items: ")
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
