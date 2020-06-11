//
//  GoToSctViewControllerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol GoToSctViewControllerDelegate: class
{
    func goToSctViewControllerDidCancel(_ goToSctViewController: GoToSctViewController)
    func goToSctViewController(_ goToSctViewController: GoToSctViewController, didChooseSct sctIndex: Int)
}
