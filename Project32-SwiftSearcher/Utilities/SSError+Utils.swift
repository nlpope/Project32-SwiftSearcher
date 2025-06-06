//  File: SSError+Utils.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import Foundation

enum SSError: String, Error
{
    case failedToLoadProjects = "Failed to load projects. Please try again."
    case failedToLoadFirstVisitStatus = "Failed to load first visit status for logo launcher."
    case dataTaskFailed = "The data task or url has failed. Please try again."
    case invalidResponse = "The response received from the source API was invalid. Please try again."
    case invalidData = "The data received from the source API was invalid. Please try again."
}
