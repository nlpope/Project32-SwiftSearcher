//  File: SSProject.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import Foundation

struct SSProject: Codable, Hashable
{
    let title: String
    let subtitle: String
    let skills: String
    let index: Int
    var completed: Bool = false
    
    func hash(into hasher: inout Hasher) { hasher.combine(title) }
}
