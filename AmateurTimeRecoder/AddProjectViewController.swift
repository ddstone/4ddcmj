//
//  AddProjectViewController.swift
//  AmateurTimeRecoder
//
//  Created by apple on 5/19/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import UIKit

class AddProjectViewController: UIViewController, UITextFieldDelegate
{
    var addProjectItem: AddProject!
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
            nameTextField.placeholder = "请输入项目名...."
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    @IBAction func add(sender: UIBarButtonItem) {
        if nameTextField.text == "" {
            Utility.presentTwoButtonAlert(self, title: "项目名不能为空", message: "", fun: nil)
        } else {
            addProjectItem.addProject(nameTextField.text!)
            cancel()
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        cancel()
    }
    
    private func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

protocol AddProject {
    func addProject(name: String)
}
