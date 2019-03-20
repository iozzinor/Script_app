//
//  AsynchronousTableManagerDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

protocol AsynchronousTableManagerDelegate: class
{
    associatedtype Section: TableSection
    associatedtype Row: TableRow
    associatedtype ErrorView: UIView
    associatedtype EmptyView: UIView
    associatedtype LoadingView: UIView
    associatedtype ViewController: UIViewController
    typealias Manager = AsynchronousTableManager<Section, Row, ErrorView, EmptyView, LoadingView, ViewController, Self>
    
    func prepareErrorView(_ errorView: ErrorView, error: Error)
    
    func asynchronousTableManager(heightForFooterView view: UIView) -> CGFloat
}
