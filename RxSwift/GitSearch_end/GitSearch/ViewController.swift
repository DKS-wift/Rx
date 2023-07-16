//
//  ViewController.swift
//  GitSearch
//
//  Created by 박의서 on 2023/06/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var viewModel = GitViewModel()
    
    var disposeBag = DisposeBag()
    
    lazy var input = GitViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    
    private let textField = UITextField().then {
        $0.backgroundColor = .white
    }
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        setLayout()
        register()
        rxBind()
        
    }
    
    private func register() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    private func rxBind() {
    
        
        self.tableView.rx.setDelegate(self)
        
        
        self.textField.rx
            .text
            .orEmpty
            .bind(to: input.text)
            .disposed(by: disposeBag)
        
        output.filteredDataSource
            .bind(to: tableView.rx.items){tableView,index,model -> TableViewCell in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: IndexPath(row: index, section: 0)) as? TableViewCell else {
                    return TableViewCell()
                }
                
                cell.dataBind(model: model)
                
                return cell
            }
            .disposed(by: disposeBag)
            
        
        
    }
}

extension ViewController {
    
    private func setLayout() {
        view.addSubviews(textField, tableView)
        textField.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(70)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(textField).offset(50)
            $0.leading.trailing.equalTo(textField)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

