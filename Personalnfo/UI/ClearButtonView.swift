//
//  ClearButtonView.swift
//  Personalnfo
//
//  Created by Мария Газизова on 01.08.2023.
//

import UIKit

class ClearButtonView: UIView {
    private let clearButton = UIButton()
    
    var onClearDataAction: (() -> Void)?
    var onClearActionShowAlert: ((UIAlertController) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(clearButton)
    }
    
    private func setConstraints() {
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            clearButton.topAnchor.constraint(equalTo: self.topAnchor),
            clearButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            clearButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configure() {
        clearButton.layer.cornerRadius = 20
        clearButton.layer.borderWidth = 2
        clearButton.layer.borderColor = UIColor.red.cgColor
        
        clearButton.setTitle("Очистить", for: .normal)
        clearButton.setTitleColor(.red, for: .normal)
        clearButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        
        clearButton.addTarget(self,
                              action: #selector(clear(_:)),
                              for: .touchUpInside)
    }
}

extension ClearButtonView {
    @IBAction func clear(_ sender: UIButton) {
        let alert = UIAlertController(title: "Предупреждение",
                                      message: "Вы действительно хотите удалить заполненные поля?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Сбросить даныные",
                                      style: UIAlertAction.Style.default) { [weak self] action in
            self?.onClearDataAction?()
        })
        alert.addAction(UIAlertAction(title: "Отмена",
                                      style: UIAlertAction.Style.cancel,
                                      handler: nil))
        onClearActionShowAlert?(alert)
    }
}
