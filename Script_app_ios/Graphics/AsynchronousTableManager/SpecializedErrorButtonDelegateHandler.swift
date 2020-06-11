//
//  ErrorDisplayerHandler.swift
//  Script_odont
//
//  Created by Régis Iozzino on 27/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

class SpecializedErrorButtonDelegateHandler: ErrorButtonDelegate
{
    fileprivate var errorButtonDelegates_: [(errorType: Error.Type, delegate: ErrorButtonDelegate)] = []
    
    func registerErrorButtonDelegate<Delegate: SpecializedErrorButtonDelegate>(_ delegate: Delegate)
    {
        errorButtonDelegates_.append((errorType: Delegate.SpecializedError.self, delegate: delegate))
    }
    
    func unregisterErrorButtonDelegate<Delegate: SpecializedErrorButtonDelegate>(_ delegate: Delegate)
    {
        let count = errorButtonDelegates_.count
        
        for i in 0..<count
        {
            let index = errorButtonDelegates_.count - i - 1
            
            if errorButtonDelegates_[index].errorType == Delegate.SpecializedError.self
            {
                errorButtonDelegates_.remove(at: index)
            }
        }
    }
    
    func errorButtonView(shouldDisplayButton errorButtonView: ErrorButtonView, error: Error) -> Bool
    {
        for (errorType, delegate) in errorButtonDelegates_
        {
            if type(of: error) == errorType
            {
                return delegate.errorButtonView(shouldDisplayButton: errorButtonView, error: error)
            }
        }
        
        return false
    }
    
    func errorButtonView(_ errorButtonView: ErrorButtonView, actionTriggeredFor error: Error)
    {
        for (errorType, delegate) in errorButtonDelegates_
        {
            if type(of: error) == errorType
            {
                delegate.errorButtonView(errorButtonView, actionTriggeredFor: error)
            }
        }
    }
    
    func errorButtonView(_ errorButtonView: ErrorButtonView, buttonTitleFor error: Error) -> String
    {
        for (errorType, delegate) in errorButtonDelegates_
        {
            if type(of: error) == errorType
            {
                return delegate.errorButtonView(errorButtonView, buttonTitleFor: error)
            }
        }
        
        return ""
    }
}
