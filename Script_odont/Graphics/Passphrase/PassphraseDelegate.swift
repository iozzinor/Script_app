//
//  PassphraseDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol PassphraseDelegate: class
{
    func passphraseViewController(_ passphraseViewController: PassphraseViewController, didChoosePassphrase passphrase: Passphrase)
}
