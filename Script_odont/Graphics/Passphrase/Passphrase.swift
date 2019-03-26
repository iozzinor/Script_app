//
//  Passphrase.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

struct Passphrase
{
    enum Kind
    {
        case sixDigitCode
        case phrase
        
        var name: String
        {
            switch self
            {
            case .sixDigitCode:
                return "Six-digit code"
            case .phrase:
                return "Alphanumeric phrase"
            }
        }
    }
    
    var kind = Kind.sixDigitCode
    var text = ""
}
