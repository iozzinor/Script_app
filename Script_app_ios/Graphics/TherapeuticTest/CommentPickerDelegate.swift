//
//  CommentPickerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 23/06/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol CommentPickerDelegate: class
{
    func commentPickerViewController(_ commentPickerViewController: CommentPickerViewController, didPickComment comment: String)
    func commentPickerViewController(didCancel commentPickerViewController: CommentPickerViewController)
}
