//
//  AddToDoViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/01/25.
//

import UIKit

class AddToDoViewController: UIViewController {

    @IBOutlet weak var addTitleTextField: UITextField!
    @IBOutlet weak var addMemoTextField: UITextField!
    @IBOutlet weak var addExpireDatePicker: UIDatePicker!
    
    var addToDo: ToDo?
    var row: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addTitleTextField.text = addToDo?.title
//        addMemoTextField.text = addToDo?.memo
//        addExpireDatePicker.date = addToDo?.expireDate
        
    }
    
    @IBAction func addToDoButton(_ sender: UIButton) {
        let addTitle = addTitleTextField.text!
        let addMemo = addMemoTextField.text!
        let addExpireDate = addExpireDatePicker.date
        
        if addTitle.isEmpty, addMemo.isEmpty {
            UIAlertController.showAlert(message: "내용을 입력해주세요", vc: self)
            return
        }
        
        let newToDo = ToDo(title: addTitle, memo: addMemo, expireDate: addExpireDate, expireTime: addExpireDate)
        ToDo.toDoList.append(newToDo)
        
        self.navigationController?.popViewController(animated: true)
    }
}


