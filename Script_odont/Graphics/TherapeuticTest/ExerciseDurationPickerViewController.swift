//
//  ExerciseDurationPickerViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 23/06/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ExerciseDurationViewController: UIViewController
{
    fileprivate static let maximumExerciseDurationYears_ = 80
    
    @IBOutlet weak var exerciseDurationPickerView: UIPickerView!
    @IBOutlet weak var yearsLabel: UILabel!
    
    weak var delegate: ExerciseDurationPickerDelegate? = nil
    
    var exerciseDuration = 0 {
        didSet {
            if isViewLoaded
            {
                exerciseDurationPickerView.selectRow(exerciseDuration, inComponent: 0, animated: true)
                updateYearsLabel_(row: exerciseDuration)
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        delegate?.exerciseDurationPickerViewController(self, didPickExerciseDuration: exerciseDurationPickerView.selectedRow(inComponent: 0))
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupExerciseDurationPickerView_()
    }
    
    fileprivate func setupExerciseDurationPickerView_()
    {
        exerciseDurationPickerView.delegate = self
        exerciseDurationPickerView.dataSource = self
        
        exerciseDurationPickerView.selectRow(exerciseDuration, inComponent: 0, animated: false)
        updateYearsLabel_(row: exerciseDuration)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE
    // -------------------------------------------------------------------------
    fileprivate func updateYearsLabel_(row: Int)
    {
        yearsLabel.text = String.localizedStringWithFormat("ExerciseDurationPicker.Year".localized, row)
    }
}

// -----------------------------------------------------------------------------
// MARK: - UI PICKER VIEW DELEGATE
// -----------------------------------------------------------------------------
extension ExerciseDurationViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        updateYearsLabel_(row: row)
    }
}

// -----------------------------------------------------------------------------
// MARK: - UI PICKER VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension ExerciseDurationViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return ExerciseDurationViewController.maximumExerciseDurationYears_ + 1
    }
}
