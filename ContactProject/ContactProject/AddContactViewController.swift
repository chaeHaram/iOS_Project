//
//  AddContactViewController.swift
//  ContactProject
//
//  Created by Chae_Haram on 2022/03/19.
//

import UIKit

class AddContactViewController: UIViewController {

    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var addPhoneNumberTextField: UITextField!
    
    static let identifier = "addContactVC"
    var editContact: Contact?
    var editName: [String?] = []
    var editRow: Int?
    var editPhoneNumber: [String?] = []
    var editFilteredName: [String?] = []
    var addOrEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let editContact = editContact {
//            addPhoneNumberTextField.text = editContact.phoneNumber
//            addNameTextField.text = editName
//        }
        if addOrEdit {
            title = "상세화면"
        } else {
            title = "새로운 연락처"
        }
        let doneRightBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addContactBarButton))
        self.navigationItem.rightBarButtonItem = doneRightBarButton
    }
    
    @objc func addContactBarButton() {
        if addOrEdit {
            let editName = addNameTextField.text!
            let editPhoneNumber = addPhoneNumberTextField.text!
            
            //guard let contact = editContact else { return }
            if Contact.contactList.phoneNumber == [editPhoneNumber] && Contact.contactList.name == [editName] {
                showAlert()
                return
            }
            let edit = Contact(phoneNumber: [editPhoneNumber], name: [editName])
            if let editRow = editRow {
                Contact.contactList
                Contact.contactList[editRow] = editContact
                Contact.name[editRow] = editName
            }
        } else {
                let addName = addNameTextField.text!
                let addPhoneNumber = addPhoneNumberTextField.text!
                let newContact = Contact(phoneNumber: addPhoneNumber)
                Contact.name.append(addName)
                Contact.contactList.append(newContact)
            }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "⚠️", message: "변경 후 다시 시도하세요.", preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(doneButton)
        present(alert, animated: true, completion: nil)
    }

}
