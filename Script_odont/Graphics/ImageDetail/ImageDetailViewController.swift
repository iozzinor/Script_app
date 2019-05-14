//
//  ImageDetailViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 22/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? = nil {
        didSet {
            if isViewLoaded
            {
                imageView.image = image
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageDetailViewController.imageTapped_))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = false
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(ImageDetailViewController.imagePinched_))
        view.addGestureRecognizer(pinchRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ImageDetailViewController.imageTranslated_))
        view.addGestureRecognizer(panRecognizer)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    @objc fileprivate func imageTapped_(_ sender: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func imagePinched_(_ sender: UIPinchGestureRecognizer)
    {
        switch sender.state
        {
        case .began, .changed:
            imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1.0
        default:
            break
        }
    }
    
    @objc fileprivate func imageTranslated_(_ sender: UIPanGestureRecognizer)
    {
        switch sender.state
        {
        case .began, .changed:
            let translation = sender.translation(in: view)
            let translated = CGPoint(x: imageView.frame.origin.x + translation.x, y: imageView.frame.origin.y + translation.y)
            imageView.frame.origin = translated
            sender.setTranslation(CGPoint.zero, in: view)
        default:
            break
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - UI VIEW CONTROLLER TRANSITIONING DELEGATE
// -----------------------------------------------------------------------------
extension ImageDetailViewController: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let horizontalViewController = presenting as? SctHorizontalViewController
        return ImageZoomAnimationController(destinationFrame: view.frame, imageView: horizontalViewController?.senderImageView)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageFadeOutAnimationController()
    }
}
