//
//  NonIndustryMemberTableViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/13/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

fileprivate let defaultCellHeight: CGFloat = 44

class ProfileTableViewController: UITableViewController {
    
    // MARK: Cells
    
    fileprivate struct ProfileCell {
        let height: CGFloat
    }
    fileprivate var cells: [ProfileCell] = [ProfileCell(height: 150),
                                            ProfileCell(height: defaultCellHeight),
                                            ProfileCell(height: defaultCellHeight),
                                            ProfileCell(height: defaultCellHeight),
                                            ProfileCell(height: defaultCellHeight),
                                            ProfileCell(height: defaultCellHeight),
                                            ProfileCell(height: defaultCellHeight),
                                            ProfileCell(height: CurrentUser().type() != "industry" ? 0 : defaultCellHeight),
                                            ProfileCell(height: CurrentUser().type() != "industry" ? 0 : defaultCellHeight),
                                            ProfileCell(height: CurrentUser().type() != "industry" ? 0 : defaultCellHeight),
                                            ProfileCell(height: CurrentUser().type() != "industry" ? 0 : 100),
                                            ProfileCell(height: 100)]
    
    // MARK: IBOutlet
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var anniversaryTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var spouseTextField: UITextField!
    @IBOutlet weak var allergiesTextField: UITextField!
    @IBOutlet weak var restaurantTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var favoriteDrinksTextField: UITextField!
    @IBOutlet weak var formerPositionsTextField: UITextView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "INHOUSE"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("UserProfile")
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        emailTextField.text = CurrentUser().email()
        cellTextField.delegate = self 
        cellTextField.text = CurrentUser().phone()
        anniversaryTextField.text = CurrentUser().anniversary()?.convertApiDateString("MMM d, yyyy")
        birthdayTextField.text = CurrentUser().birthday()?.convertApiDateString("MMM d, yyyy")
        spouseTextField.text = CurrentUser().spouseName()
        allergiesTextField.text = CurrentUser().allergies()
        
        nameLabel.text = CurrentUser().name()
        if CurrentUser().type() == "industry" {
            typeLabel.text = "Industry Member"
            restaurantTextField.text = CurrentUser().restaurant()
            positionTextField.text = CurrentUser().position()
            favoriteDrinksTextField.text = CurrentUser().drinks()
            formerPositionsTextField.text = CurrentUser().formerPositions()
        } else {
            typeLabel.text = "INHOUSE Member"
        }
    }
}

// MARK: TableView Methods

extension ProfileTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cells[indexPath.row].height
    }
}

// MARK: UITextFieldDelegate

extension ProfileTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cellTextField {
            return range.location < 12
        }
        return true
    }
}
