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
    static var isFirstVisitStatus: Bool! = fetchFirstVisitStatus() {
        didSet { PersistenceManager.saveFirstVisitStatus(status: self.isFirstVisitStatus) }
    }
    
    //-------------------------------------//
    // MARK: - ADD / REMOVE FROM PROJECTS ARRAY
    
    // see app delegate
    static func updateProjectsWith(project: SSProject, actionType: ProjectPersistenceActionType, completionHandler: @escaping (SSError?) -> Void)
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
    
    
    static func handle(actionType: ProjectPersistenceActionType, for project: SSProject, inArray projects: inout [SSProject])
    {
        switch actionType {
        case .add:
            projects.removeAll { $0.title == project.title }
            projects.append(project)
        case .remove:
            projects.removeAll { $0.title == project.title }
        }
    }
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH PROJECTS ARRAY
    
    static func saveProjects(_ projects: [SSProject]) -> SSError?
    {
        do {
            let encoder = JSONEncoder()
            let encodedProjects = try encoder.encode(projects)
            defaults.setValue(encodedProjects, forKey: SaveKeys.projects)
            return nil
        } catch {
            print("error = \(error)")
            return .failedToSaveProjects
        }
    }

    
    static func fetchProjects(completed: @escaping (Result<[SSProject], SSError>) -> Void)
    {
        guard let encodedProjects = defaults.object(forKey: SaveKeys.projects) as? Data
        else { completed(.success([])); return }
        
        do {
            let decoder = JSONDecoder()
            let fetchedProjects = try decoder.decode([SSProject].self, from: encodedProjects)
            completed(.success(fetchedProjects))
        } catch {
            completed(.failure(.failedToLoadProjects))
        }
    }
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH FIRST VISIT STATUS (FOR LOGO LAUNCHER)
    
    static func saveFirstVisitStatus(status: Bool)
    {
        do {
            let encoder = JSONEncoder()
            let encodedStatus = try encoder.encode(status)
            defaults.set(encodedStatus, forKey: SaveKeys.isFirstVisit)
        } catch {
            print("failed ato save visit status"); return
        }
    }
    
    
    static func fetchFirstVisitStatus() -> Bool
    {
        guard let visitStatusData = defaults.object(forKey: SaveKeys.isFirstVisit) as? Data
        else { return true }
        
        do {
            let decoder = JSONDecoder()
            let fetchedStatus = try decoder.decode(Bool.self, from: visitStatusData)
            return fetchedStatus
        } catch {
            print("unable to load first visit status")
            return true
        }
    }
}
