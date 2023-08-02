//
//  ViewController.swift
//  Personalnfo
//
//  Created by Мария Газизова on 01.08.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var personalInfo = PersonalInfoView()
    private var tableView = UITableView()
    private var tableCellId = "ChildTableCell"
    
    private lazy var clearButtonView = ClearButtonView()
    private lazy var tableHeaderView = ChildTableHeaderView()
    
    var viewModel = PersonalInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setConstraints()
        configure()
        bind()
    }

    private func setup() {
        view.addSubview(personalInfo)
        view.addSubview(tableView)
        view.addSubview(clearButtonView)
    }
    
    private func setConstraints() {
        personalInfo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personalInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            personalInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            personalInfo.topAnchor.constraint(equalTo: view.topAnchor),
            personalInfo.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: personalInfo.bottomAnchor, constant: 8)
        ])
        
        clearButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            clearButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            clearButtonView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            clearButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            clearButtonView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChildTableViewCell.self, forCellReuseIdentifier: tableCellId)
    }
    
    private func bind() {
        viewModel.onReloadView = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onTooManyChildrenAction = { [weak self] in
            self?.tableHeaderView.onHideButton?()
        }
        
        viewModel.onFreeChildrenAction = { [weak self] in
            self?.tableHeaderView.onShowButton?()
        }
        
        viewModel.onClear = { [weak self] in
            self?.personalInfo.onClear?()
        }
        
        tableHeaderView.onAddChild = { [weak self] in
            self?.viewModel.addChild()
        }
        
        clearButtonView.onClearActionShowAlert = { [weak self] alert in
            self?.present(alert, animated: true, completion: nil)
        }
        
        clearButtonView.onClearDataAction = { [weak self] in
            self?.viewModel.clear()
        }
        
        personalInfo.onNameHasChanged = { [weak self] name in
            self?.viewModel.setPersonsName(name)
        }
        
        personalInfo.onAgeHasChanged = { [weak self] age in
            self?.viewModel.setPersonsAge(age)
        }
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId,
                                                       for: indexPath) as? ChildTableViewCell else {
            let cell = ChildTableViewCell()
            cell.configure(with: viewModel, tag: indexPath)
            return cell
        }
        cell.configure(with: viewModel, tag: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.person.childrenArray.count == 0 ? 1 : viewModel.person.childrenArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
