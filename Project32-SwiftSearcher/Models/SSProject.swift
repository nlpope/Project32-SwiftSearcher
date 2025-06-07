//  File: SSProject.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import Foundation

struct APIPayload: Codable
{
    let data: [SSProject]
}

struct SSProject: Codable, Hashable
{
    let title, subtitle, skills: String
    let index: Int    
    
    func hash(into hasher: inout Hasher) { hasher.combine(title) }
}
