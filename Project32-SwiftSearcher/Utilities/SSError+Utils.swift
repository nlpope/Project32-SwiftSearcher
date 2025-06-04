//  File: SSError+Utils.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import Foundation

enum SSError: String, Error
{
    case failedToSaveProjects = "Failed to save projects."
    case failedToLoadProjects = "Failed to load projects."
    case failedToLoadFirstVisitStatus = "Failed to load first visit status"
}
