//  File: SSTableViewDiffableDataSource.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/13/25.

import UIKit

class SSTableViewDiffableDataSource: UITableViewDiffableDataSource<Section, SSProject>
{
    weak var delegate: HomeVC!
    
    //-------------------------------------//
    // MARK: - TABLEVIEW DELEGATE METHODS 2/2

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    { return true }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let currentProject = delegate.projects[indexPath.row]
        if editingStyle == .insert {
            delegate.updateFavorites(with: currentProject, actionType: .add)
            tableView.cellForRow(at: indexPath)?.editingAccessoryType = .checkmark
        }
        else {
            delegate.updateFavorites(with: currentProject, actionType: .remove)
            tableView.cellForRow(at: indexPath)?.editingAccessoryType = .none
        }
    }
}
