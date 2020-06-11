//
//  SctSearchCriterionPickerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 16/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol SctSearchCriterionPickerDelegate: class
{
    func sctSearchCriterionPicker(didCancelPick sctSearchCriterionPickerViewContorller: SctSearchCriterionPickerViewController)
    func sctSearchCriterionPicker(_ sctSearchCriterionPickerViewController: SctSearchCriterionPickerViewController, didPickCriterion pickedCriterion: SctSearchCriterion)
}
