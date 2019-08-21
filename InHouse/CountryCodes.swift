//
//  CountryCodes.swift
//  InHouse
//
//  Created by Kevin Johnson on 9/1/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation
import UIKit

let countryCodes: [CountryCode] = [CountryCode.init(description: "United States +1", rawNumber: 1, charLimit: 10),
                                   CountryCode.init(description: "United Kingdom +44", rawNumber: 44, charLimit: 10)]

struct CountryCode {
    var description: String
    var rawNumber: Int
    var charLimit: Int
    
    init(description: String, rawNumber: Int, charLimit: Int) {
        self.description = description
        self.rawNumber = rawNumber
        self.charLimit = charLimit
    }
}

protocol CountryCodePickerDelegate: class {
    func selectedCountryCode(_ code: CountryCode)
}

class CountryCodePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    weak var countryDelegate: CountryCodePickerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
    }
    
    // MARK: DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryCodes.count
    }
    
    // MARK: Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryCodes[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryDelegate?.selectedCountryCode(countryCodes[row])
    }
}
