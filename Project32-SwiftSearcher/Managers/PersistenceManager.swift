//  File: PersistenceManager.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import Foundation

enum PersistenceActionType
{
    case add, remove
}

enum PersistenceManager
{
    static private let defaults = UserDefaults.standard
    static var isFirstVisitStatus: Bool! = fetchFirstVisitStatus() {
        didSet { PersistenceManager.saveFirstVisitStatus(status: isFirstVisitStatus) }
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
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH / UPDATE FAVORITES
    
    static func updateFavorites(with project: SSProject, actionType: PersistenceActionType, completed: @escaping (SSError?) -> Void)
    {
        fetchFavorites { result in
            switch result {
            case .success(var favorites):
                handle(actionType, for: project, in: &favorites) { error in
                    if error != nil { completed(error); return }
                }
                completed(save(favorites: favorites))
            /**--------------------------------------------------------------------------**/
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func handle(_ action: PersistenceActionType, for project: SSProject, in projects: inout [SSProject], completed: @escaping (SSError?) -> Void)
    {
        switch action {
        case .add:
            guard !projects.contains(project) else { completed(.alreadyInFavorites); return }
            projects.append(project)
        /**--------------------------------------------------------------------------**/
        case .remove:
            projects.removeAll { $0.title == project.title }
        }
    }
    
    
    static func fetchFavorites(completed: @escaping (Result<[SSProject], SSError>) -> Void)
    {
        guard let favoritesData = defaults.object(forKey: SaveKeys.favorites) as? Data
        else { completed(.success([])); return }
        
        do {
            let decoder = JSONDecoder()
            let decodedFavorites = try decoder.decode([SSProject].self, from: favoritesData)
            completed(.success(decodedFavorites))
        } catch {
            completed(.failure(.failedToFavorite))
        }
    }
    
    
    static func save(favorites: [SSProject]) -> SSError?
    {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: SaveKeys.favorites)
            return nil
        } catch {
            return .failedToFavorite
        }
    }
}
