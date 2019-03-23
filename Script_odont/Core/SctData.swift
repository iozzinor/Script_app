//
//  SctData.swift
//  Script_odont
//
//  Created by Régis Iozzino on 22/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public struct SctData
{
    public enum Content
    {
        case text(String)
        case image(UIImage)
    }
    
    fileprivate var content_ = Content.text("")
    public var content: Content {
        return content_
    }
    
    init()
    {
    }
    
    init(content: Content)
    {
        self.content_ = content
    }
    
    init(text: String)
    {
        self.content_ = Content.text(text)
    }
    
    init(image: UIImage)
    {
        self.content_ = Content.image(image)
    }
    
    var text: String? {
        switch content_
        {
        case let .text(text):
            return text
        case .image(_):
            return nil
        }
    }
    
    var image: UIImage? {
        switch content_
        {
        case let .image(image):
            return image
        case .text(_):
            return nil
        }
    }
}
