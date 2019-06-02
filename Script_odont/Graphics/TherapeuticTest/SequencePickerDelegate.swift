//
//  SequencePickerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/06/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol SequencePickerDelegate: class
{
    func sequencePickerDidPick(_ sequencePickerViewController: SequencePickerViewController, sequenceNumber: Int)
}
