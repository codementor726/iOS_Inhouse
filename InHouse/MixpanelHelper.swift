//
//  MixpanelHelper.swift
//  InHouse
//
//  Created by Kevin Johnson on 9/18/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Mixpanel

struct MixpanelHelper {
    static func screenView(_ name: String) {
        Mixpanel.mainInstance().track(event: "ScreenView",
                                      properties:["Screen" : name])
    }
    
    static func buttonTap(_ button: String) {
        Mixpanel.mainInstance().track(event: "ButtonTap",
                                      properties:["Button" : button])
    }
    
    static func setUser(name: String, email: String) {
        let properties = ["name" : name,
                          "email" : email]
        
        Mixpanel.mainInstance().people.set(properties: properties)
    }
}
