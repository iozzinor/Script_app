//
//  Constants.swift
//  Script_odont
//
//  Created by Régis Iozzino on 08/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

struct Constants
{
    static var deviceOrientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    static var isDeviceOrientationHorizontal: Bool {
        switch UIDevice.current.orientation
        {
        case .portrait, .portraitUpsideDown:
            return false
        case .faceDown, .faceUp, .landscapeLeft, .landscapeRight, .unknown:
            return true
        }
    }
}
