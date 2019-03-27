//
//  SebdNetworkError.swift
//  Script_odont
//
//  Created by Régis Iozzino on 27/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SebdNetworkError: SpecializedErrorButtonDelegate
{
    typealias SpecializedError = NetworkError
    
    func errorButtonView(shouldDisplayButton errorButtonView: ErrorButtonView, error: NetworkError) -> Bool
    {
        return true
    }
    
    func errorButtonView(_ errorButtonView: ErrorButtonView, actionTriggeredFor error: NetworkError)
    {
        UIApplication.shared.openPreferences()
    }
    
    func errorButtonView(_ errorButtonView: ErrorButtonView, buttonTitleFor error: NetworkError) -> String
    {
        return error.fixTip
    }
}
