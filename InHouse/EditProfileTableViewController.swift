//
//  EditProfileTableViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/13/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class EditProfileTableViewController: ProfileTableViewController {
    
    // MARK: UI
    
    lazy var birthdayPicker = UIDatePicker.init()
    lazy var anniversaryPicker = UIDatePicker.init()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView.init(frame: .zero)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: Fonts.Colfax.Bold(16), NSAttributedStringKey.foregroundColor: Colors.OffWhite], for: .normal)
        
        anniversaryPicker.datePickerMode = .date
        anniversaryPicker.maximumDate = Date()
        if let anniversary: Date = CurrentUser().anniversary()?.convertApiDateStringToDate() {
            anniversaryPicker.date = anniversary
        }
        anniversaryTextField.inputView = anniversaryPicker
        anniversaryPicker.addTarget(self, action: #selector(anniversaryChanged), for: .valueChanged)
        
        birthdayPicker.datePickerMode = .date
        birthdayPicker.maximumDate = Date()
        if let birthday: Date = CurrentUser().birthday()?.convertApiDateStringToDate() {
            birthdayPicker.date = birthday
        }
        birthdayTextField.inputView = birthdayPicker
        birthdayPicker.addTarget(self, action: #selector(birthdayChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("EditProfile")
    }
    
    // MARK: Change
    
    @objc func anniversaryChanged() {
        let date = anniversaryPicker.date
        anniversaryTextField.text = date.stringWithFormat("MMM d, yyyy")
    }
    
    @objc func birthdayChanged() {
        let date = birthdayPicker.date
        birthdayTextField.text = date.stringWithFormat("MMM d, yyyy")
    }
    
    // MARK: IBAction
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        MixpanelHelper.buttonTap("SaveProfileEdits")
        let fields = generateFields()
        guard validUpdate(), fields.count > 0 else { return }
        
        InHouseAPI.shared.editUser(fields: fields) { (success, user, error) in
            if success {
                self.updateCurrentUser(fields)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showMessage("Error Editing Profile", title: "Error")
            }
        }
    }
}

// MARK: Validation

extension EditProfileTableViewController {
    func validUpdate()-> Bool {
        var validators = [ValidationReturn]()
        
        validators.append(Validation.validEmail(emailTextField.text))
        validators.append(Validation.validPhone(cellTextField.text?.intString()))
        
        if CurrentUser().type() == "industry" {
            validators.append(Validation.validString(restaurantTextField.text, emptyMessage: Validation.Message.RestaurantEmpty))
            validators.append(Validation.validString(positionTextField.text, emptyMessage: Validation.Message.PositionEmpty))
            validators.append(Validation.validString(favoriteDrinksTextField.text, emptyMessage: "Favorite Cocktails Empty"))
            validators.append(Validation.validString(formerPositionsTextField.text, emptyMessage: "Former Positions Empty"))
        }
        
        for validation in validators {
            if !validation.valid {
                showMessage(nil, title: validation.message)
                return false
            }
        }
        return true
    }
}

// MARK: Update


extension EditProfileTableViewController {
    fileprivate struct Update {
        var key: String
        var value: String?
        var current: String?
        
        init(key: String, value: String?, current: String?) {
            self.key = key
            self.value = value
            self.current = current
        }
    }
    
    fileprivate func updates()-> [Update] {
        return [Update(key: Keys.User.Email, value: emailTextField.text, current: (CurrentUser().email())),
                Update(key: Keys.User.Phone, value: cellTextField.text?.intString(), current: (CurrentUser().phone())),
                Update(key: Keys.User.Birthday, value: birthdayTextField.text != nil ? birthdayTextField.text!.convertFormattedDateStringToApi("MMM d, yyyy") : nil, current: CurrentUser().birthday()),
                Update(key: Keys.User.Anniversary, value: anniversaryTextField.text != nil ? anniversaryTextField.text!.convertFormattedDateStringToApi("MMM d, yyyy") : nil, current: CurrentUser().anniversary()),
                Update(key: Keys.User.SpouseName, value: spouseTextField.text, current: CurrentUser().spouseName()),
                Update(key: Keys.User.Allergies, value: allergiesTextField.text, current: CurrentUser().allergies()),
                Update(key: Keys.User.Drinks, value: favoriteDrinksTextField.text, current: CurrentUser().drinks()),
                Update(key: Keys.User.Restaurant, value: restaurantTextField.text, current: CurrentUser().restaurant()),
                Update(key: Keys.User.Position, value: positionTextField.text, current: CurrentUser().position()),
                Update(key: Keys.User.FormerPositions, value: formerPositionsTextField.text, current: CurrentUser().formerPositions())]
    }
    
    
    fileprivate func generateFields()-> [String: Any] {
        var fields = [String: Any]()
        updates().forEach { update in
            if update.value != update.current || update.value == nil && update.current != nil || update.value != nil && update.current == nil {
                fields[update.key] = update.value ?? NSNull()
            }
        }
        return fields
    }
    
    fileprivate func updateCurrentUser(_ fields: [String: Any]) {
        updates().forEach { update in
            if let unwrapped = fields[update.key] {
                if let _ = unwrapped as? NSNull {
                    CurrentUser().removeKey(update.key)
                } else {
                    CurrentUser().setValue(unwrapped, key: update.key)
                }
            }
        }
    }
}
