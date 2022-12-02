//
//  SearchView.swift
//  BookSearch
//
//  Created by 강휘 on 2022/12/01.
//

import Foundation
import UIKit

final class SearchView: UIView {
    public let textField = SearchTextField()
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = Layout.tableViewCellHeight
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    private func setUI() {
        [textField, tableView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
