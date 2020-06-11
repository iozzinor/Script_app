//
//  UIViewController+segueId.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UIViewController
{
    /// The storyboad identifier associated to the view controller.
    ///
    /// The format is: `<current controller name>StoryboardId`.
    static var storyboardId: String {
        return String(describing: self) + "StoryboardId"
    }
}
