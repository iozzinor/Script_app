//
//  ToothRecognitionSelectionDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 14/04/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation
import ToothCommon

protocol ToothRecognitionSelectionDelegate: class
{
    func toothRecognitionSelection(didCancel toothRecognitionSelection: ToothRecognitionSelectionViewController)
    func toothRecognitionSelection(_ toothRecognitionSelection: ToothRecognitionSelectionViewController, didSelect tooth: Tooth, correctTooth: Tooth)
}

