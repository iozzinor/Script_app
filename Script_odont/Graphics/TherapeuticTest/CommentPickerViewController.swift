//
//  CommentPickerViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 19/06/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class CommentPickerViewController: UIViewController
{
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var commentTextView: UITextView!
    
    weak var delegate: CommentPickerDelegate? = nil
    
    var comment: String {
        set {
            comment_ = newValue
            if isViewLoaded
            {
                updateCommentTextView_()
            }
        }
        get {
            return comment_
        }
    }
    
    fileprivate var comment_: String = ""
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupCancel_()
        setupDone_()
        updateCommentTextView_()
    }
    
    fileprivate func setupCancel_()
    {
        cancelButton.title = "Common.Cancel".localized
    }
    
    fileprivate func setupDone_()
    {
        doneButton.title = "Common.Done".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE
    // -------------------------------------------------------------------------
    fileprivate func updateCommentTextView_()
    {
        commentTextView.text = comment_
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func cancel(_ button: UIBarButtonItem)
    {
        delegate?.commentPickerViewController(didCancel: self)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ button: UIBarButtonItem)
    {
        comment_ = commentTextView.text
        delegate?.commentPickerViewController(self, didPickComment: self.comment)
        
        dismiss(animated: true, completion: nil)
    }
}
