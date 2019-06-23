//
//  ExerciseDurationPickerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 23/06/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol ExerciseDurationPickerDelegate: class
{
    func exerciseDurationPickerViewController(_ exerciseDurationPickerViewController: ExerciseDurationViewController, didPickExerciseDuration exerciseDuration: Int)
}
