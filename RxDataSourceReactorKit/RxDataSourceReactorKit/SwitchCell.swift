//
//  SwitchCell.swift
//  RxDataSourceReactorKit
//
//  Created by 강병우 on 2020/09/21.
//

import UIKit

import ReactorKit

class SwitchCell: UITableViewCell, View {
    
    typealias Reactor = SwitchCellReactor
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - view
    let titleLabel = UILabel()
    let mkSwitch: MKSwitch = MKSwitch().then {
        $0.thumbOnColor = .red
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [titleLabel, mkSwitch].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(10)
        }
        
        mkSwitch.snp.makeConstraints {
            $0.trailing.equalTo(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: SwitchCellReactor) {
        self.titleLabel.text = reactor.currentState.displayData.title
    }
}
