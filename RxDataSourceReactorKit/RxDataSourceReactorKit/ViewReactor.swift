//
//  ViewReactor.swift
//  RxDataSourceReactorKit
//
//  Created by 강병우 on 2020/09/21.
//

import UIKit

import ReactorKit
import RxDataSources

class ViewReactor: Reactor {
    
    // MARK: - Constants
    enum CellType {
        case defaultCell(String, String)
        case switchCell(String)
    }
    
    // MARK: - Property
    let initialState: State
    
    // MARK: - Constants
    enum Action {
        case cellSelected(IndexPath)
    }
    
    enum Mutation {
        case setSelectedIndexPath(IndexPath?)
    }
    
    struct State {
        var selectedIndexPath: IndexPath?
        var sections: [TableViewCellSection]
    }
    
    init() {
        self.initialState = State(
            sections: ViewReactor.configSections()
        )
    }

    // MARK: - func
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cellSelected(let indexPath):
            return Observable.concat([
                Observable.just(Mutation.setSelectedIndexPath(indexPath)),
                Observable.just(Mutation.setSelectedIndexPath(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSelectedIndexPath(let indexPath):
            newState.selectedIndexPath = indexPath
        }
        return newState
    }
	
	static func configSections() -> [TableViewCellSection] {
		
		let defaultCell = TableViewCellSectionItem.defaultCell(DefaultCellReactor(state: CellDataModel(title: "세상에 나쁜 아라찌는 없다.", subTitle: "아라찌")))
		
		let defaultCell2 = TableViewCellSectionItem.defaultCell(DefaultCellReactor(state: CellDataModel(title: "웃어서 행복한거다.", subTitle: "노홍철")))
		
		let defaultsection = TableViewCellSection.first([defaultCell, defaultCell2])
		
		let switchCell = TableViewCellSectionItem.switchCell(SwitchCellReactor(displayData: CellDataModel(title: "스위치 셀")))
		
		let switchSection = TableViewCellSection.switchS([switchCell])
		
		return [defaultsection, switchSection]
	}
    
//    static func configSections() -> [TableViewSectionModel] {
//        var sections: [TableViewSectionModel] = []
//
//        let displayData: [[CellType]] = [
//            // 1
//            [.defaultCell("세상에 나쁜 아라찌는 없다..", "- 아라찌"), .defaultCell("웃어서 행복한거다..", "- 노홍철")],
//            // 2
//            [.switchCell("스위치 셀..")]
//        ]
//
//        for cellSection in displayData {
//            var section: [TableViewCellSections] = []
//            for item in cellSection {
//                switch item {
//                case let .defaultCell(title, subTitle):
//                    let item: TableViewCellSections = .defaultCell(DefaultCellReactor(state: CellDataModel(title: title, subTitle: subTitle)))
//                    section.append(item)
//                case let .switchCell(title):
//                    let item: TableViewCellSections = .switchCell(SwitchCellReactor(displayData: CellDataModel(title: title)))
//                    section.append(item)
//                }
//            }
//            sections.append(TableViewSectionModel(model: Void(), items: section))
//        }
//
//        return sections
//    }
}
