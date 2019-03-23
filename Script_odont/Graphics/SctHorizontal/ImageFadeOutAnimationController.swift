//
//  ImageFadeOutAnimationController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 23/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ImageFadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        guard let destinationViewController = transitionContext.viewController(forKey: .to),
            let sourceViewController = transitionContext.viewController(forKey: .from),
            let snapshot = sourceViewController.view.snapshotView(afterScreenUpdates: true)
                else
        {
            return
        }
        
        sourceViewController.view.isHidden = true
        
        let containerView = transitionContext.containerView
        containerView.addSubview(destinationViewController.view)
        containerView.addSubview(snapshot)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            snapshot.alpha = 0.0
        }, completion: {
                (_) -> Void in
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
