//  File: NetworkManager.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/6/25.

import UIKit

class NetworkManager
{
    static let shared = NetworkManager()
    private let apiURL = APIKeys.url
    
    private init() {}
    
    func fetchProjects(completed: @escaping(Result<[SSProject], SSError>) -> Void)
    {
        guard let url = URL(string: apiURL)
        else { completed(.failure(.failedToLoadProjects)); return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { completed(.failure(error as! SSError)); return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else { completed(.failure(.invalidResponse)); return }
            
            guard let data = data else { completed(.failure(.invalidData)); return }
            print(data)
            
            do {
                let decoder = JSONDecoder()
                // PROB CHILD
                //                let projects = try decoder.decode([SSProject].self, from: data)
                let projects = try decoder.decode(Token.self, from: data)
                completed(.success(projects))
            } catch {
                print(error)
                completed(.failure(.decodingFailure))
            }
        }
        task.resume()
    }
}
