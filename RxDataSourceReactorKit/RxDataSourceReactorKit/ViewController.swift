//
//  ViewController.swift
//  RxDataSourceReactorKit
//
//  Created by 강병우 on 2020/09/20.
//

import UIKit

import RxDataSources
import Then
import SnapKit
import ReusableKit
import ReactorKit

class ViewController: UIViewController, View {
    
    typealias Reactor = ViewReactor
    
    // MARK: - Constants
    struct Reusable {
        static let defaultCell = ReusableCell<DefaultCell>()
        static let switchCell = ReusableCell<SwitchCell>()
    }
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<TableViewSectionModel>(configureCell: { dataSource, tableView, indexPath, sectionItems in
        
        switch sectionItems {
        case let .defaultCell(reactor):
            let cell = tableView.dequeue(Reusable.defaultCell, for: indexPath)
            cell.reactor = reactor
            return cell
            
        case let .switchCell(reactor):
            let cell = tableView.dequeue(Reusable.switchCell, for: indexPath)
            cell.reactor = reactor
            return cell
        }
    })

    // MARK: - view
    let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .systemGroupedBackground
        $0.register(Reusable.defaultCell)
        $0.register(Reusable.switchCell)
    }
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.snp.makeConstraints {
            $0.center.edges.equalToSuperview()
        }
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBackground
        self.view = view
        
        view.addSubview(tableView)
    }
    
    // MARK: - Binding
    func bind(reactor: ViewReactor) {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // action
        tableView.rx.itemSelected
            .map{Reactor.Action.cellSelected($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // state
        reactor.state.map{$0.selectedIndexPath}
            .compactMap {$0}
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
        
        // ui
        reactor.state.map{$0.sections}.asObservable()
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
