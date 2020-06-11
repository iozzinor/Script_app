//
//  ParticipantCategoryPickerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 24/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol ParticipantCategoryPickerDelegate: class
{
    func participantCategoryPicker(_ participantCategoryPickerViewController: ParticipantCategoryPickerViewController, didPickCategory participantCategory: ParticipantCategory?)
}
