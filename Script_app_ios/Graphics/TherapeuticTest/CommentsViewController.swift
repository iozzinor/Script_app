//
//  CommentsViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 05/07/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var comments = [TctComment]() {
        didSet {
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibCell(CommentCell.self)
        tableView.separatorColor = nil
    }
    
    // -------------------------------------------------------------------------
    // ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func done(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
}

extension CommentsViewController: UITableViewDelegate
{
}

extension CommentsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(for: indexPath) as CommentCell
        
        cell.displayComment(comments[indexPath.row])
        /*cell.stackView.layer.cornerRadius = 5
        cell.stackView.layer.borderWidth = 3
        cell.stackView.layer.borderColor = UIColor.black.cgColor
        cell.stackView.layer.shadowOffset = CGSize(width: 4, height: 3)
        cell.stackView.layer.shadowColor = UIColor.black.cgColor*/
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return comments.count
    }
}
