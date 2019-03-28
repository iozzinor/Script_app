//
//  UIImage+utils.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UIImage
{
    public func createImage(usingColor color: UIColor) -> UIImage
    {
        let imageFrame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIGraphicsBeginImageContext(imageFrame.size)
        guard let context = UIGraphicsGetCurrentContext(),
            let cgImage = self.cgImage else
        {
            return self
        }
        context.clip(to: imageFrame, mask: cgImage)
        context.setFillColor(color.cgColor)
        context.fill(imageFrame)
        
        if let result = context.makeImage()
        {
            UIGraphicsEndImageContext()
            return UIImage(cgImage: result, scale: 1.0, orientation: .downMirrored)
        }
        
        UIGraphicsEndImageContext()
        return self
    }
}
