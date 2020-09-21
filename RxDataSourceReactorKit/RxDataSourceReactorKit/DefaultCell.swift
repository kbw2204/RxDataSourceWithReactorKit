//
//  DefaultCell.swift
//  RxDataSourceReactorKit
//
//  Created by 강병우 on 2020/09/20.
//

import UIKit

import ReactorKit

class DefaultCell: UITableViewCell, View {
    
    typealias Reactor = DefaultCellReactor
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - view
    let titleLabel = UILabel()
    let detailLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 10)
    }
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.distribution = .equalSpacing
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [titleLabel, detailLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: DefaultCellReactor) {
        self.titleLabel.text = reactor.currentState.title
        self.detailLabel.text = reactor.currentState.subTitle
    }
}
