//
//  ThreadHelper.swift
//  LogInOut
//
//  Created by Akshay Tandel on 08/06/23.
//

import Foundation
import CoreLocation


// main thared banavelo
/// runs code in block on main thread
/// - Parameter block: code block
public func runOnMainThread(_ block: @escaping () -> ()) {
    DispatchQueue.main.async(execute: {
        block()
    })
}
