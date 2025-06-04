//  File: PersistenceManager.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import Foundation

enum ProjectPersistenceActionType
{
    case add, remove
}

enum PersistenceManager
{
    static private let defaults = UserDefaults.standard
    
    //-------------------------------------//
    // MARK: - ADD / REMOVE FROM PROJECTS ARRAY
    
    // see app delegate
    static func updateProjectsWith(project: Project, actionType: ProjectPersistenceActionType, completionHandler: @escaping (SSError?) -> Void)
    {
        fetchProjects { result in
            switch result {
            case .success(var projects):
                handle(actionType: actionType, for: project, inArray: &projects)
                completionHandler(saveProjects(projects))
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    
    static func handle(actionType: ProjectPersistenceActionType, for project: Project, inArray projects: inout [Project])
    {
        switch actionType {
        case .add:
            projects.append(project)
        case .remove:
            projects.removeAll { $0.title == project.title }
        }
    }
    
    //-------------------------------------//
    // MARK: - SAVE / LOAD PROJECTS ARRAY
    
    static func saveProjects(_ projects: [Project]) -> SSError?
    {
        do {
            let encoder = JSONEncoder()
            let encodedProjects = try encoder.encode(projects)
            defaults.setValue(encodedProjects, forKey: SaveKeys.projects)
            return nil
        } catch {
            return SSError.failedToSaveProjects
        }
    }
    
    
    // im an escaping closure that takes parameter: Result and return nothing
    static func fetchProjects(completed: @escaping (Result<[Project], SSError>) -> Void)
    {
        guard let encodedProjects = defaults.object(forKey: SaveKeys.projects) as? Data
        else { completed(.success([])); return }
        
        do {
            let decoder = JSONDecoder()
            let fetchedProjects = try decoder.decode([Project].self, from: encodedProjects)
            completed(.success(fetchedProjects))
        } catch {
            
        }
    }
}
