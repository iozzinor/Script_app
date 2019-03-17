//
//  DatePickerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 16/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol DatePickerDelegate: class
{
    func datePicker(_ datePickerViewController: DatePickerViewController, didPickDate date: Date)
}
