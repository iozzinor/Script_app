//
//  WalkthroughContentViewControllerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController
{
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionDescriptionLabel: UILabel!
    
    var sectionTitle: String = ""
    var sectionDescription: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        sectionTitleLabel.text = sectionTitle
        sectionDescriptionLabel.text = sectionDescription
    }
}
