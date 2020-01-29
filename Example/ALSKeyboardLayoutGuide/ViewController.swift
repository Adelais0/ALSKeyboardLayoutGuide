//
//  ViewController.swift
//  ALSKeyboardLayoutGuide
//
//  Created by lilingfeng on 01/29/2020.
//  Copyright (c) 2020 lilingfeng. All rights reserved.
//

import UIKit
import ALSKeyboardLayoutGuide

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let label = UILabel()
        label.textColor = .black
        label.text = "I'm above keyboard and inside safe area!"
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor, constant: -8.0).isActive = true
        if #available(iOS 11.0, *) {
            label.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0).isActive = true
        } else {
            label.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -8.0).isActive = true
        }
        let constraint = label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        constraint.priority = UILayoutPriority(1)
        constraint.isActive = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

