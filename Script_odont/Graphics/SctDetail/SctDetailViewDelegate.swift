//
//  SctDetailViewDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol SctDetailViewDelegate: class
{
    // vote
    func sctDetailView(_ sctDetailViewController: SctDetailViewController, didPerformVote vote: Double)
    func sctDetailView(_ sctDetailViewController: SctDetailViewController, didUpdateVote vote: Double)
    func sctDetailView(didRemoveVote sctDetailViewController: SctDetailViewController)
}
