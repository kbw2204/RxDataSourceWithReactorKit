//
//  DefaultCellReactor.swift
//  RxDataSourceReactorKit
//
//  Created by 강병우 on 2020/09/21.
//

import ReactorKit

class DefaultCellReactor: Reactor {
    
    typealias Action = NoAction
    
    // MARK: - Property
    let initialState: CellDataModel
    
    init(state: CellDataModel) {
        self.initialState = state
    }
}
