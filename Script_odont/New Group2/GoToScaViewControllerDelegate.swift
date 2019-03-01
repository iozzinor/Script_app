//
//  GoToScaViewControllerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol GoToScaViewControllerDelegate: class
{
    func goToScaViewControllerDidCancel(_ goToScaViewController: GoToScaViewController)
    func goToScaViewController(_ goToScaViewController: GoToScaViewController, didChooseSca scaIndex: Int)
}
