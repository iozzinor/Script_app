//
//  NewDataViewDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public protocol NewDataDelegate: class
{
    func newDataView(_ newDataView: NewDataView, didClickImageView imageView: UIImageView)
}
