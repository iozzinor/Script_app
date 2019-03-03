//
//  QualificationTopicPickerViewControllerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 03/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol QualificationTopicPickerViewControllerDelegate: class
{
    func qualificationTopicPickerViewController(_ qualificationTopicPickerViewController: QualificationTopicPickerViewController,
                                           didPickQualificationTopic qualificationTopic: QualificationTopic)
}
