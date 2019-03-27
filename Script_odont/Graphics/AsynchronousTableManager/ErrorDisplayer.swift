//
//  ErrorDisplayer.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol ErrorDisplayer: TableViewFooter
{
    func prepareFor(error: Error)
}
