//
//  WeakContainer.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

class WeakContainer<T>
{
    weak var t: AnyObject? = nil
    
    init(t: T?)
    {
        self.t = t as AnyObject
    }
    
    var referred: T? {
        return t as? T
    }
}
