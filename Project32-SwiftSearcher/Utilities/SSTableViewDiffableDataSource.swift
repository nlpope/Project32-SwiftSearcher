//  File: SSTableViewDiffableDataSource.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/13/25.

import UIKit
import CoreSpotlight
import MobileCoreServices

/** this subclass is here only to make the 'commit editingStyle' override method work */
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
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            index(project: currentProject)
        }
        else {
            delegate.updateFavorites(with: currentProject, actionType: .remove)
            tableView.cellForRow(at: indexPath)?.editingAccessoryType = .none
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            deindex(item: currentProject)
        }
    }
    
    //-------------------------------------//
    // MARK: - INDEXING (ENABLES SPOTLIGHT SEARCHING)
    
    func index(project: SSProject)
    {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: UTType.text.description as String)
        attributeSet.title = project.title
        attributeSet.contentDescription = project.subtitle
        
        let item = CSSearchableItem(uniqueIdentifier: "\(project.index)",
                                    domainIdentifier: "com.hackingwithswift",
                                    attributeSet: attributeSet)
        item.expirationDate = Date.distantFuture
        
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error { print("Indexing error: \(error)") }
            else { print("Search item successfully indexed!") }
        }
    }
    
    
    func deindex(item: SSProject)
    {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item.index)"]) { error in
            if let error = error { print("Deindexing error: \(error)") }
            else { print("Search item successfully removed!") }
        }
    }
}
