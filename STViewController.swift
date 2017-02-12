//
//  STViewController.swift
//  SwiftTodo
//
//  Created by Полина Абросимова on 11.02.17.
//  Copyright © 2017 Полина Абросимова. All rights reserved.
//

import UIKit
import CoreData

class STViewController: UIViewController {
    
    var thatText: String = ""
    var isEdit: Bool = true

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isEdit {
            textView.becomeFirstResponder()
        }
        else {
            saveBtn.alpha = 0
            textView.text = thatText as String
            textView.isEditable = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        // back
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveBtnPressed(_ sender: Any) {
        // save data
        if textView.text != "" {
        let todoToSave: String = textView.text
        
        let savings = CoreData ()
        savings.saveNewTodo(todo: todoToSave)
        
        self.dismiss(animated: true, completion: nil)
        }
        else {
            showAlertWithMessage(message: "Text field is empty!")
        }
    }
    
    func showAlertWithMessage (message: String) {
        let alert = UIAlertController (title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil));
        show(alert, sender: self)
    }
}
