//  File: SSProject.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import Foundation

struct Token: Codable
{
    let projects: Response
}

struct SSProject: Codable, Hashable
{
    var data: String
    
    let title: String
    let subtitle: String
    let skills: String
//    let index: Int
    let index: String
//    var completed: Bool = false
    
//    enum CodingKeys: String, CodingKey
//    {
//        case title: String
//        case subtitle
//    }
    
    func hash(into hasher: inout Hasher) { hasher.combine(title) }
}

struct Response: Codable, Hashable
{
    var data: String
    
    let title: String
    let subtitle: String
    let skills: String
//    let index: Int
    let index: String
//    var completed: Bool = false
    
//    enum CodingKeys: String, CodingKey
//    {
//        case title: String
//        case subtitle
//    }
    
    func hash(into hasher: inout Hasher) { hasher.combine(title) }
}
