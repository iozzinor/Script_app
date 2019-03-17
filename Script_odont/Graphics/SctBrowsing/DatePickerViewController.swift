//
//  DatePickerViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 16/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController
{
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var minimumDate: Date? = nil
    {
        didSet
        {
            if isViewLoaded
            {
                datePicker.minimumDate = minimumDate
            }
        }
    }
    var date = Date()
    {
        didSet
        {
            if isViewLoaded
            {
                datePicker.date = date
            }
        }
    }
    var maximumDate: Date? = nil
    {
        didSet
        {
            if isViewLoaded
            {
                datePicker.maximumDate = maximumDate
            }
        }
    }
    weak var delegate: DatePickerDelegate? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        datePicker.minimumDate = minimumDate
        datePicker.date = date
        datePicker.maximumDate = maximumDate
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        delegate?.datePicker(self, didPickDate: datePicker.date)
    }
}
