//  File: Constants+Utils.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import Foundation

enum SaveKeys
{
    static let isFirstVisit = "isFirstVisitStatus"
    static let favorites = "Favorites"
}

enum VideoKeys
{
    static let launchScreen = "launchscreen"
    static let playerLayerName = "PlayerLayerName"
}

enum APIKeys
{
    static let url = "https://script.googleusercontent.com/macros/echo?user_content_key=AehSKLj3HghpUiBStGhFDt2xUrC0kr04TFZexzmDj9ceTnriyfaR1PNN2VHdBv5VoNwjRQaJHi85tmS2b7MatBHKgoSTiP8DLbSvwaSvacbVMz-QP02Nhm0KQhz3uTXuVMA4a2GdbQfHXrHumlrpvYQ1sAvSPmyzxVjFcSJMiJRv_XqL8jx9SZkwRX9_W8w64N_iAuyNaDy0O0pP-028nlA_2RXBQkzBXWxcsdcH3wlNeQ66ODmJGbrHIPqy4DNUMBGXCEkXx8kFjIWzkXm0Vt5uFfEGkoonZWqQ27IL1BOG&lib=MsMgVF71SPV94u1r4ViQfL5RVNQaJTCcF"
}

enum AlertKeys
{
    static let saveSuccessTitle = "Added to favorites 🥳"
    static let saveSuccessMsg = "Successfully added to your favorites list. This is will be denoted by a checkmark next to the project"
    
    static let removeSuccessTitle = "Removed from favorites"
    static let removeSuccessMsg = "This project was successfully removed from your favorites."
}

enum URLKeys
{
    static let baseURL = "https://www.hackingwithswift.com/read/"
}
