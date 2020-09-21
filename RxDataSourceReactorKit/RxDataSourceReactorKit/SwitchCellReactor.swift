//
//  SwitchCellReactor.swift
//  RxDataSourceReactorKit
//
//  Created by 강병우 on 2020/09/21.
//

import ReactorKit

class SwitchCellReactor: Reactor {
    
    // MARK: - Property
    let initialState: State
    
    // MARK: - Constants
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var displayData: CellDataModel
    }
    
    init(displayData: CellDataModel) {
        self.initialState = State(displayData: displayData)
    }

    // MARK: - func
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        }
        return newState
    }
}
