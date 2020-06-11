//
//  SctData.swift
//  Script_odont
//
//  Created by Régis Iozzino on 22/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

/// The data associated to the SCT.
///
/// It is the new datum, that affects the hypothesis,
/// and whose impact is to be evaluated.
public struct SctData
{
    /// The type of the associated data.
    public enum Content
    {
        /// A text.
        case text(String)
        
        /// An image.
        case image(UIImage)
        
        /// The URL of the volume resource (STL file by example).
        case volume(String)
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
        case .image(_), .volume(_):
            return nil
        }
    }
    
    var image: UIImage? {
        switch content_
        {
        case let .image(image):
            return image
        case .text(_), .volume(_):
            return nil
        }
    }
}
