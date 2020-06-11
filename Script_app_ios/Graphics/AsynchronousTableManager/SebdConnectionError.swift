//
//  SebdNetworkError.swift
//  Script_odont
//
//  Created by Régis Iozzino on 27/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation
import UIKit

class SebdConnectionError: SpecializedErrorButtonDelegate
{
    weak var viewController: ViewController?
    
    init(viewController: ViewController?)
    {
        self.viewController = viewController
    }
    
    func errorButtonView(shouldDisplayButton errorButtonView: ErrorButtonView, error: ConnectionError) -> Bool
    {
        return true
    }
    
    func errorButtonView(_ errorButtonView: ErrorButtonView, actionTriggeredFor error: ConnectionError)
    {
        switch error
        {
        case .wrongCredentials, .noAccountLinked:
            break
        case .accountNoActivated:
            let url = URL(string: "message://")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func errorButtonView(_ errorButtonView: ErrorButtonView, buttonTitleFor error: ConnectionError) -> String
    {
        return error.fixTip
    }
    
    typealias SpecializedError = ConnectionError
}
