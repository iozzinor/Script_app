//
//  String+localized.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

extension String
{
    var localized: String
    {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with comment: String) -> String
    {
        return NSLocalizedString(self, comment: comment)
    }
}
