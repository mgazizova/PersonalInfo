//
//  ChildTableHeaderView.swift
//  Personalnfo
//
//  Created by Мария Газизова on 01.08.2023.
//

import UIKit

class ChildTableHeaderView: UIView {
    private let label = UILabel()
    private let addChildButton = UIButton()

    var onHideButton: (() -> Void)?
    var onShowButton: (() -> Void)?
    var onAddChild: (() -> Void)?
    
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
        self.addSubview(label)
        self.addSubview(addChildButton)
    }
    
    private func setConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
        ])
        
        addChildButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addChildButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addChildButton.topAnchor.constraint(equalTo: self.topAnchor),
            addChildButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            addChildButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configure() {
        self.backgroundColor = .white
        
        label.text = "Дети (макс. 5)"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        
        addChildButton.layer.cornerRadius = 20
        addChildButton.layer.borderWidth = 2
        addChildButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        addChildButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addChildButton.setTitle(" Добавить ребенка", for: .normal)
        addChildButton.setTitleColor(.systemBlue, for: .normal)
        addChildButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        
        addChildButton.addTarget(self,
                                 action: #selector(addChild(_:)),
                                 for: .touchUpInside)
    }
    
    private func bind() {
        onHideButton = { [weak self] in
            DispatchQueue.main.async {
                self?.addChildButton.isHidden = true
            }
        }
        
        onShowButton = { [weak self] in
            DispatchQueue.main.async {
                self?.addChildButton.isHidden = false
            }
        }
    }
    
    @IBAction func addChild(_ sender: UIButton) {
        onAddChild?()
    }
}
