//
//  SpecializedErrorButtonDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 27/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol SpecializedErrorButtonDelegate: ErrorButtonDelegate
{
    associatedtype SpecializedError: Error
    
    func errorButtonView(shouldDisplayButton errorButtonView: ErrorButtonView, error: SpecializedError) -> Bool
    func errorButtonView(_ errorButtonView: ErrorButtonView, actionTriggeredFor error: SpecializedError)
    func errorButtonView(_ errorButtonView: ErrorButtonView, buttonTitleFor error: SpecializedError) -> String
}

extension SpecializedErrorButtonDelegate
{
    func errorButtonView(shouldDisplayButton errorButtonView: ErrorButtonView, error: Error) -> Bool
    {
        if let specializedError = error as? SpecializedError
        {
            return self.errorButtonView(shouldDisplayButton: errorButtonView, error: specializedError)
        }
        return false
    }
    
    func errorButtonView(_ errorButtonView: ErrorButtonView, actionTriggeredFor error: Error)
    {
        if let specializedError = error as? SpecializedError
        {
            self.errorButtonView(errorButtonView, actionTriggeredFor: specializedError)
        }
    }
    
    func errorButtonView(_ errorButtonView: ErrorButtonView, buttonTitleFor error: Error) -> String
    {
        if let specializedError = error as? SpecializedError
        {
            return self.errorButtonView(errorButtonView, buttonTitleFor: specializedError)
        }
        return ""
    }
}
