//
//  PersonalInfoView.swift
//  Personalnfo
//
//  Created by Мария Газизова on 01.08.2023.
//

import UIKit

class PersonalInfoView: UIView, UITextFieldDelegate {
    private let title = UILabel()
    private let nameField = TextField()
    private let ageField = TextField()
    
    var onClear: (() -> Void)?
    var onNameHasChanged: ((String?) -> Void)?
    var onAgeHasChanged: ((String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setConstraints()
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))

        self.addSubview(title)
        self.addSubview(nameField)
        self.addSubview(ageField)
    }
    
    private func setConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
        title.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16)
        ])
        
        ageField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ageField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            ageField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            ageField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 8),
            ageField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ageField.heightAnchor.constraint(equalTo: nameField.heightAnchor)
        ])
    }
    
    private func configure() {
        title.text = "Персональные данные"
        title.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        
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
    }
    
    private func bind() {
        onClear = { [weak self] in
            self?.nameField.text = ""
            self?.ageField.text = ""
        }
    }
}

extension PersonalInfoView {
    @IBAction func nameHasChanged(_ textField: UITextField) {
        onNameHasChanged?(textField.text)
    }
    
    @IBAction func ageHasChanged(_ textField: UITextField) {
        onAgeHasChanged?(textField.text)
    }
}

extension PersonalInfoView {
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
        }
    }
}
