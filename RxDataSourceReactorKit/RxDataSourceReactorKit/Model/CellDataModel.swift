//
//  CellDataModel.swift
//  RxDataSourceReactorKit
//
//  Created by 강병우 on 2020/09/20.
//

struct CellDataModel {
    
    var title: String
    var subTitle: String?
    
    init(title: String, subTitle: String? = nil) {
        self.title = title
        self.subTitle = subTitle
    }
}
