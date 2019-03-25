//
//  ErrorButtonDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 25/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol ErrorButtonDelegate: class
{
    func errorButtonView(shouldDisplayButton errorButtonView: ErrorButtonView, error: Error) -> Bool
    func errorButtonView(_ errorButtonView: ErrorButtonView, actionTriggeredFor error: Error)
    func errorButtonView(_ errorButtonView: ErrorButtonView, buttonTitleFor error: Error) -> String
}
