//
//  OneTimeOTPCodeTextField.swift
//  OtpCodeExample
//
//  Created by Mirac Okan on 14.12.2023.
//

import Foundation
import UIKit

class OneTimeOTPCodeTextField : UITextField {
    
    var didEnterLastDigit : ((String) -> Void)?
    var defaultCharacter = "-"
    private var isConfigured = false
    private var digitLabels = [UILabel]()
    
    private lazy var tapRecognizer : UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    func configure(with slotCount : Int = 6) {
        guard isConfigured == false else {
            return
        }
        isConfigured.toggle()
        configuredTextField()
        
        let labelStackView = createLabelWithStackView(with: slotCount)
        addSubview(labelStackView)
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configuredTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createLabelWithStackView(with count : Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 32)
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            label.layer.borderColor = UIColor.darkGray.cgColor
            label.layer.borderWidth = 1.0
            label.layer.cornerRadius = 5
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
        }
        
        return stackView
    }
    
    @objc private func textDidChange() {
        
        guard let text = self.text,
              text.count <= digitLabels.count else {
            return
        }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text = defaultCharacter
            }
        }
        
        if text.count == digitLabels.count {
            didEnterLastDigit?(text)
        }
        
    }
    
}

extension OneTimeOTPCodeTextField : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let charCount = textField.text?.count else {
            return false
        }
        return charCount < digitLabels.count || string == ""
    }
}
