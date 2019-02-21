//
//  WalkthroughPageViewControllerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol WalkthroughPageViewControllerDelegate
{
    func walkthroughPageViewController(
        _ walkthroughPageViewController: WalkthroughPageViewController,
        didTransistionToSectionAtIndex sectionIndex: Int)
}
