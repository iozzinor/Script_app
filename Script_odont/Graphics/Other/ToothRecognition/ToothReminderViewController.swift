//
//  ToothReminderViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 09/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import ToothCommon
import UIKit

class ToothReminderViewController: UIViewController
{
    var toothToRemind = Tooth(internationalNumber: 11) {
        didSet {
            if isViewLoaded
            {
                updateTooth_()
            }
        }
    }
    
    @IBOutlet weak var toothImage: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateTooth_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE
    // -------------------------------------------------------------------------
    fileprivate func updateTooth_()
    {
        navigationItem.title = "\(toothToRemind.internationalNumber)"
        updateToothImage_()
        updateReminderText_()
    }
    
    fileprivate func updateToothImage_()
    {
        guard let toothImagePath = Bundle.main.path(forResource: "mesial_14", ofType: "png", inDirectory: "ToothReminder")
            else
        {
            print("url not found")
            return
        }
        
        guard  let image = UIImage(contentsOfFile: toothImagePath)
            else
        {
            print("can not load image at path \(toothImagePath)")
            return
        }
        
        toothImage.image = image
    }
    
    fileprivate func updateReminderText_()
    {
        reminderLabel.text = """
La 4 est plus volumineuse que la 5 (dent du haut en série descendante).
La cuspide palatine de la 5 est plus petite que la cuspide vestibulaire. La 4 a
plus souvent 2 racines que la 5 (1 V + 1 P). Elle peut même avoir 3 racines : 2 vestibulaires et une palatine, avec un tronc s’étendant jusqu’au 1/3 apical (taurodontie).
"""
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTION
    // -------------------------------------------------------------------------
    @IBAction func done(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
}
