//
//  Section.swift
//  RxDataSourceReactorKit
//
//  Created by Seokho on 2020/09/22.
//

import RxDataSources

enum TableViewCellSection {
	case first([TableViewCellSectionItem])
	case switchS([TableViewCellSectionItem])
}
enum TableViewCellSectionItem {
	case defaultCell(DefaultCellReactor)
	case switchCell(SwitchCellReactor)
}
extension TableViewCellSection: SectionModelType {
	
	typealias Item = TableViewCellSectionItem
	
	var items: [Item] {
		switch self {
		case .first(let items):
			return items
		case .switchS(let items):
			return items
		}
	}
	
	init(original: TableViewCellSection, items: [TableViewCellSectionItem]) {
		switch original {
		case .first:
			self = .first(items)
		case .switchS:
			self = .switchS(items)
		}
	}
	
}
