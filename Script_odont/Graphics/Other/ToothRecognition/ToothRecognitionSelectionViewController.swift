//
//  ToothRecognitionSelectionViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 14/04/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import ToothCommon
import UIKit

class ToothRecognitionSelectionViewController: UIViewController
{
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var imageTeethView: IpImageTeethView!
    
    var correctTooth: Tooth = Tooth(internationalNumber: 11)
    weak var delegate: ToothRecognitionSelectionDelegate? = nil
    
    fileprivate var orientationHorizontal_ = Constants.isDeviceOrientationHorizontal
    fileprivate let maxillarPosition_ = TeethPosition.getPosition(for: .maxillars, face: .buccal)
    fileprivate let mandibularPosition_ = TeethPosition.getPosition(for: .mandibulars, face: .buccal)
    fileprivate var maxillarHeight_: CGFloat = 0.0
    
    fileprivate var tapGestureRecognizer_ = UITapGestureRecognizer()
    fileprivate var selectedIndex_: Int? = nil
    fileprivate var selectionPerformed_: Bool = false
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        setup_()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "ToothRecognitionSelection.NavigationItem.Title".localized
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        maxillarHeight_ = maxillarPosition_.height(forWidth: imageTeethView.frame.width)
        imageTeethView.reloadData()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupImageTeethView_()
        setupOrientation_()
        setupTapSelection_()
        
        doneButton.isEnabled = false
    }
    
    fileprivate func setupImageTeethView_()
    {
        imageTeethView.delegate = self
        imageTeethView.dataSource = self
        
        maxillarHeight_ = maxillarPosition_.height(forWidth: imageTeethView.frame.width)
    }
    
    fileprivate func setupOrientation_()
    {
        // register for device orientation changed notification
        NotificationCenter.default.addObserver(self, selector: #selector(ToothRecognitionSelectionViewController.deviceOrientationDidChange_), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    fileprivate func setupTapSelection_()
    {
        tapGestureRecognizer_.addTarget(self, action: #selector(ToothRecognitionSelectionViewController.makeSelection_))
        tapGestureRecognizer_.numberOfTapsRequired = 1
        tapGestureRecognizer_.numberOfTouchesRequired = 1
        
        imageTeethView.addGestureRecognizer(tapGestureRecognizer_)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TOOTH
    // -------------------------------------------------------------------------
    fileprivate func getTooth_(forIndex toothIndex: Int) -> Tooth
    {
        if toothIndex < 8
        {
            return Tooth(internationalNumber: 18 - toothIndex)
        }
        else if toothIndex < 16
        {
            return Tooth(internationalNumber: 21 + toothIndex - 8)
        }
        else if toothIndex < 24
        {
            return Tooth(internationalNumber: 48 - toothIndex + 16)
        }
        return Tooth(internationalNumber: 31 + toothIndex - 24)
    }
    
    fileprivate func getIndex_(forTooth tooth: Tooth) -> Int
    {
        switch tooth.quadrant
        {
        case 1:
            return 8 - tooth.number
        case 2:
            return tooth.number + 8 - 1
        case 4:
            return 8 - tooth.number + 16
        case 3:
            return tooth.number + 24 - 1
        default:
            return -1
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - NOTIFICATIONS
    // -------------------------------------------------------------------------
    @objc fileprivate func deviceOrientationDidChange_(_ sender: Any)
    {
        let newOrientation = Constants.isDeviceOrientationHorizontal
        if newOrientation != orientationHorizontal_
        {
            orientationHorizontal_ = newOrientation
            maxillarHeight_ = maxillarPosition_.height(forWidth: imageTeethView.frame.width)
            imageTeethView.reloadData()
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        delegate?.toothRecognitionSelection(didCancel: self)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func performSelection(_ sender: UIBarButtonItem)
    {
        selectionPerformed_ = true
        
        let correctIndex = getIndex_(forTooth: correctTooth)
        let selectedTooth = getTooth_(forIndex: selectedIndex_!)
        
        // display the correct tooth
        // and display the wrong tooth
        imageTeethView.reloadTeethViews(for: [correctIndex, selectedIndex_!])
        
        delegate?.toothRecognitionSelection(self, didSelect: selectedTooth, correctTooth: correctTooth)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc fileprivate func makeSelection_(_ sender: UITapGestureRecognizer)
    {
        let point = sender.location(in: imageTeethView)
        
        let newSelectedIndex = retrieveToothIndex_(forTouchedPoint: point)
        
        // select the tooth if there were no selections
        if selectedIndex_ == nil
        {
            selectedIndex_ = newSelectedIndex
            imageTeethView.reloadToothView(for: newSelectedIndex)
        }
        // deselect the tooth if it was already selected
        else if selectedIndex_ == newSelectedIndex
        {
            selectedIndex_ = nil
            imageTeethView.reloadToothView(for: newSelectedIndex)
        }
        // unselect the previous one and select the new one
        else
        {
            let previousIndex = selectedIndex_!
            selectedIndex_ = newSelectedIndex
            imageTeethView.reloadTeethViews(for: [newSelectedIndex, previousIndex])
        }
        
        // update the done button
        doneButton.isEnabled = (selectedIndex_ != nil)
    }
    
    fileprivate func retrieveToothIndex_(forTouchedPoint point: CGPoint) -> Int
    {
        let isMaxillar = point.y < imageTeethView.frame.height / 2
        let position = isMaxillar ? maxillarPosition_ : mandibularPosition_
        
        // first guess
        var guessedArchIndex = Int(floor(point.x / (imageTeethView.frame.width / 16)))
        var guessedIndex = (isMaxillar ? 0 : 16) + guessedArchIndex
        var guessedTooth = getTooth_(forIndex: guessedIndex)
        var guessedFrame = position.frame(for: guessedTooth, width: imageTeethView.frame.width)
        
        // to low
        if point.x > guessedFrame.maxX
        {
            while point.x > guessedFrame.maxX
            {
                guessedArchIndex += 1
                guessedIndex = (isMaxillar ? 0 : 16) + guessedArchIndex
                guessedTooth = getTooth_(forIndex: guessedIndex)
                guessedFrame = position.frame(for: guessedTooth, width: imageTeethView.frame.width)
            }
            
            return guessedIndex
        }
        // to high
        else if point.x < guessedFrame.minX
        {
            while point.x < guessedFrame.minX
            {
                guessedArchIndex -= 1
                guessedIndex = (isMaxillar ? 0 : 16) + guessedArchIndex
                guessedTooth = getTooth_(forIndex: guessedIndex)
                guessedFrame = position.frame(for: guessedTooth, width: imageTeethView.frame.width)
            }
            
            return guessedIndex
        }
        // correct
        else
        {
            return guessedIndex
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - IP IMAGE TEETH VIEW DELEGATE
// -----------------------------------------------------------------------------
extension ToothRecognitionSelectionViewController: IpImageTeethViewDelegate
{
    func imageTeethView(_ imageTeethView: IpImageTeethView, frameFor toothIndex: Int) -> CGRect
    {
        let currentTooth = getTooth_(forIndex: toothIndex)
        // maxillar teeth
        if toothIndex < 16
        {
            let toothFrame = maxillarPosition_.frame(for: currentTooth, width: imageTeethView.frame.width)
            return CGRect(x: toothFrame.minX, y: toothFrame.minY + imageTeethView.frame.height / 2 - maxillarHeight_, width: toothFrame.width, height: toothFrame.height)
        }
        
        // mandibular teeth
        let toothFrame = mandibularPosition_.frame(for: currentTooth, width: imageTeethView.frame.width, verticalFlip: true)
        
        return CGRect(x: toothFrame.minX, y: toothFrame.minY + imageTeethView.frame.height / 2, width: toothFrame.width, height: toothFrame.height)
    }
    
    func imageTeethView(_ imageTeethView: IpImageTeethView, scaleFor toothIndex: Int) -> CGFloat
    {
        return 1.0
    }
    
    func imageTeethView(_ imageTeethView: IpImageTeethView, verticalFlipFor toothIndex: Int) -> Bool
    {
        return toothIndex > 15
    }
    
    func imageTeethView(_ imageTeethView: IpImageTeethView, horizontalFlipFor toothIndex: Int) -> Bool
    {
        return false
    }
    
    func imageTeethView(_ imageTeethView: IpImageTeethView, widthShiftFor toothIndex: Int) -> CGFloat
    {
        return 0.5
    }
    
    func imageTeethView(_ imageTeethView: IpImageTeethView, heightShiftFor toothIndex: Int) -> CGFloat
    {
        return 0.5
    }
    
    func imageTeethView(_ imageTeethView: IpImageTeethView, lineWidthFor toothIndex: Int) -> CGFloat
    {
        if toothIndex == selectedIndex_
        {
            return 5.0
        }
        return 3.0
    }
    
    func imageTeethView(_ imageTeethView: IpImageTeethView, clearColorFor toothIndex: Int) -> CGColor
    {
        return UIColor.white.cgColor
    }
    
    func imageTeethView(_ imageTeethView: IpImageTeethView, strokeColorFor toothIndex: Int) -> CGColor
    {
        if toothIndex == selectedIndex_
        {
            if selectionPerformed_
            {
                return correctTooth == getTooth_(forIndex: selectedIndex_ ?? -1) ? UIColor.green.cgColor : UIColor.red.cgColor
            }
            else
            {
                return UIColor.blue.cgColor
            }
        }
        else if selectionPerformed_ && correctTooth == getTooth_(forIndex: toothIndex)
        {
            return UIColor.green.cgColor
        }
        return UIColor.black.cgColor
    }
    
    func imageTeethView(_ imageTeethView: IpImageTeethView, fillColorFor toothIndex: Int) -> CGColor
    {
        return UIColor.white.cgColor
    }
}

// -----------------------------------------------------------------------------
// MARK: - IP IMAGE TEETH VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension ToothRecognitionSelectionViewController: IpImageTeethViewDataSource
{
    func imageTeethView(teethCountFor imageTeethView: IpImageTeethView) -> Int
    {
        return 32
    }
    
    func imageTeethView(_ imageTeethView: IpImageTeethView, toothFor toothIndex: Int) -> Tooth
    {
        return getTooth_(forIndex: toothIndex)
    }
    
    func imageTeethView(_ imageTeethView: IpImageTeethView, faceFor toothIndex: Int) -> Tooth.Face
    {
        return .buccal
    }
}
