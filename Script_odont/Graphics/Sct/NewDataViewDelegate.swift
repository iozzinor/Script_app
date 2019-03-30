//
//  NewDataViewDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit
import SceneKit

public protocol NewDataDelegate: class
{
    func newDataView(_ newDataView: NewDataView, didClickImageView imageView: UIImageView)
    
    func newDataView(_ newDataView: NewDataView, didClickVolumeView scnView: SCNView)
}
