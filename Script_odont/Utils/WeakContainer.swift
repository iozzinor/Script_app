//
//  WeakContainer.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// Hold a weak reference.
class WeakContainer<T>
{
    /// The holded object.
    weak var t: AnyObject? = nil
    
    /// Initialize the holder with a weak reference.
    ///
    /// - parameter t: The object to refer to.
    init(t: T?)
    {
        self.t = t as AnyObject
    }
    
    /// The object referred to.
    var referred: T? {
        return t as? T
    }
}
