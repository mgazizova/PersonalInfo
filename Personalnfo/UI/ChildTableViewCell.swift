//
//  ChildTableViewCell.swift
//  Personalnfo
//
//  Created by Мария Газизова on 01.08.2023.
//

import UIKit

class ChildTableViewCell: UITableViewCell, UITextFieldDelegate {
    private let nameField = TextField()
    private let ageField = TextField()
    private let deleteButton = UIButton()
    private var viewModel: PersonalInfoViewModel?
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setConstraints()
        configure()
    }
    
    func configure(with viewModel: PersonalInfoViewModel,
                   tag: IndexPath) {
        self.viewModel = viewModel
        self.nameField.text = viewModel.person.childrenArray[tag.row].name
        if let age = viewModel.person.childrenArray[tag.row].age {
            self.ageField.text = "\(age)"
        } else {
            self.ageField.text = ""
        }
        self.nameField.tag = tag.row
        self.ageField.tag = tag.row
        self.deleteButton.tag = tag.row
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(nameField)
        contentView.addSubview(ageField)
        contentView.addSubview(deleteButton)
    }
    
    private func setConstraints() {
        nameField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameField.widthAnchor.constraint(equalToConstant: contentView.frame.size.width - 100),
            nameField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
        
        ageField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ageField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            ageField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            ageField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            ageField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            ageField.heightAnchor.constraint(equalTo: nameField.heightAnchor)
        ])
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: nameField.trailingAnchor, constant: 8),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.topAnchor.constraint(equalTo: nameField.topAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func configure() {
        self.selectionStyle = .none
        
        nameField.placeholder = "Имя"
        nameField.addTarget(self,
                       action: #selector(nameHasChanged(_:)),
                       for: .editingChanged)
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.layer.cornerRadius = 5
        
        ageField.delegate = self
        ageField.placeholder = "Возраст"
        ageField.addTarget(self,
                      action: #selector(ageHasChanged(_:)),
                      for: .editingChanged)
        ageField.layer.borderWidth = 1
        ageField.layer.borderColor = UIColor.lightGray.cgColor
        ageField.layer.cornerRadius = 5
        ageField.keyboardType = .numberPad
        
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.systemBlue, for: .normal)
        deleteButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        
        deleteButton.addTarget(self,
                               action: #selector(deleteChild(_:)),
                               for: .touchUpInside)
    }
}

extension ChildTableViewCell {
    @IBAction func nameHasChanged(_ textField: UITextField) {
        viewModel?.setName(textField.text, for: textField.tag)
    }
    
    @IBAction func ageHasChanged(_ textField: UITextField) {
        viewModel?.setAge(textField.text, for: textField.tag)
    }
    
    @IBAction func deleteChild(_ sender: UIButton) {
        viewModel?.deleteChild(at: sender.tag)
    }
}

extension ChildTableViewCell {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard string.count > 0 else {
            return true
        }
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        let isNumber = allowedCharacters.isSuperset(of: characterSet)
        let isAllowedLength = textField.text?.count ?? 0 < 3
        return isNumber && isAllowedLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let age = Int(textField.text ?? ""),
           age > 150 {
            textField.text = "150"
            ageHasChanged(textField)
        }
    }
}
