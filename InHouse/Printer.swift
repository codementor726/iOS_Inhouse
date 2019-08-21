//
//  Printer.swift
//
//
//  Created by Kevin Johnson on 12/30/16.
//  Copyright © 2016 Majestyk Apps. All rights reserved.
//

struct Printer {
    public static func print(_ object: Any) {
        #if DEBUG
            Swift.print(object)
        #endif
    }
}
