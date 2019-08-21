//
//  Coordinates.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/24/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation

// MARK: - Public Func

public func delayOnMainThread(_ delay: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
