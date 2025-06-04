//  File: SSProject.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import Foundation

struct SSProject: Codable
{
    let title: String
    let subTitle: String
    let index: Int
    var completed: Bool = false
}
