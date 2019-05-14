//
//  ImageZoomAnimationController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 22/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ImageZoomAnimationController: NSObject, UIViewControllerAnimatedTransitioning
{
    static private let largerRatio: CGFloat = 1.2
    
    private let destinationFrame: CGRect
    private let imageView: UIImageView?
    
    init(destinationFrame: CGRect, imageView: UIImageView?)
    {
        self.destinationFrame = destinationFrame
        self.imageView = imageView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        guard let originViewController = transitionContext.viewController(forKey: .from),
            let destinationViewController = transitionContext.viewController(forKey: .to),
            let originImageView = imageView
            else
        {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.white
        containerView.frame = originViewController.view.frame
        
        // sizes
        let finalFrame = transitionContext.finalFrame(for: destinationViewController)
        let destinationImageSize = originImageView.image?.size ?? CGSize(width: 1, height: 1)
        let destinationImageFrame = imageFrame_(imageSize: destinationImageSize, viewControllerFrame: finalFrame)
        let largerImageFrame = getLargeFrame_(frame: destinationImageFrame, ratio: ImageZoomAnimationController.largerRatio)

        let transitionImageView = UIImageView()
        let transitionImageViewFrame = originImageView.convert(originImageView.frame, to: originViewController.view)
        transitionImageView.image = originImageView.image
        transitionImageView.frame = scaleImageFrame_(image: originImageView, frame: transitionImageViewFrame)
        
        transitionImageView.contentMode = .scaleAspectFill
    
        containerView.addSubview(destinationViewController.view)
        containerView.addSubview(transitionImageView)
        
        destinationViewController.view.isHidden = true
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.8, animations: {
                transitionImageView.frame = largerImageFrame
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                transitionImageView.frame = destinationImageFrame
            })
        }, completion: {
            (_) -> Void in
            destinationViewController.view.isHidden = false
            
            transitionImageView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    /// Returns the current image frame, as the scale has been modified
    /// to display the whole image and keep the ratio.
    fileprivate func scaleImageFrame_(image: UIImageView, frame: CGRect) -> CGRect
    {
        let imageSize = image.image?.size ?? CGSize(width: 1, height: 1)
        
        // invert width and height because the screen is in landscape
        let imageRatio = imageSize.height / imageSize.width
        let frameRatio = frame.width / frame.height
        
        let width: CGFloat
        let height: CGFloat
        
        if frameRatio < imageRatio
        {
            width = frame.width / imageRatio
            height = frame.height
        }
        else
        {
            width = frame.width
            height = frame.height * imageRatio
        }
        
        return CGRect(x: frame.minX + (frame.width - width) / 2,
                    y: frame.minY + (frame.height - height) / 2,
                    width: width,
                    height: height)
    }
    
    fileprivate func imageFrame_(imageSize: CGSize, viewControllerFrame: CGRect) -> CGRect
    {
        let imageRatio = imageSize.width / imageSize.height
        let viewControllerRatio = viewControllerFrame.width / viewControllerFrame.height
        
        let width: CGFloat
        let height: CGFloat
        
        if imageRatio < viewControllerRatio
        {
            width = viewControllerFrame.width
            height = viewControllerFrame.height * imageRatio
        }
        else
        {
            width = viewControllerFrame.width / imageRatio
            height = viewControllerFrame.height
        }
        
        let destinationImageOrigin = CGPoint(x: (viewControllerFrame.width - width) / 2.0, y: (viewControllerFrame.height - height) / 2.0)
        let destinationImageFrame = CGRect(origin: destinationImageOrigin, size: CGSize(width: width, height: height))
        
        return destinationImageFrame
    }
    
    fileprivate func getLargeFrame_(frame: CGRect, ratio: CGFloat) -> CGRect
    {
        let newWidth = ratio * frame.width
        let newHeight = ratio * frame.height
        return CGRect(x: frame.minX + (frame.width - newWidth) / 2.0,
                      y: frame.minY + (frame.height - newHeight) / 2.0,
                      width: newWidth,
                      height: newHeight)
    }
}
