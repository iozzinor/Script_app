//
//  QualificationPickerViewControllerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 03/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol QualificationPickerViewControllerDelegate: class
{
    func qualificationPickerViewController(_ qualificationPickerViewController: QualificationPickerViewController,
                                           didPickQualification qualification: Qualification)
}
