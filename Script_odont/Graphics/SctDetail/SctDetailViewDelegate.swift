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
    func sctDetailView(_ sctDetailViewController: SctDetailViewController, didPerformVote vote: Int)
    func sctDetailView(_ sctDetailViewController: SctDetailViewController, didUpdateVote vote: Int)
    func sctDetailView(didRemoveVote sctDetailViewController: SctDetailViewController)
    
    // resume
    func sctDetailView(didResume sctDetailViewController: SctDetailViewController)
}
