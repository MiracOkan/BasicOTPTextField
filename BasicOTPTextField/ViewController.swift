//
//  ViewController.swift
//  OtpCodeExample
//
//  Created by Mirac Okan on 14.12.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var codeTextFiedl: OneTimeOTPCodeTextField!
    @IBOutlet weak var testField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextFiedl.defaultCharacter = "#"
        codeTextFiedl.configure()
        codeTextFiedl.didEnterLastDigit = { [weak self] code in
            print(code)
        }
        
        testField.textContentType = .oneTimeCode
        testField.keyboardType = .numberPad
    }
    
}

