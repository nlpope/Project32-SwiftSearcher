//  File: HomeVC.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import UIKit

class HomeVC: UITableViewController
{
    var projects = [Project]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createProjects()
    }
    
    
    func createProjects()
    {
        createProject(index: 1, title: "Storm Viewer", subTitle: "Constants & variables, UITableView, UIImageViw, FileManager, storyboards")

        createProject(index: 2, title: "Guess the Flag", subTitle: "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController")
        
        createProject(index: 3, title: "Social Media", subTitle: "UIBarButtonItem, UIActivityViewController, the Social framework, URL")
        
        createProject(index: 4, title: "Easy Browser", subTitle: "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView, key-value observing")
        
        createProject(index: 5, title: "Word Scramble", subTitle: "Closures, method return values, booleans, NSRange")
        
        createProject(index: 6, title: "Auto Layout", subTitle: "Get to grips with Auto Layout using practical examples and code")
        
        createProject(index: 7, title: "Whitehouse Petitions", subTitle: "JSON, Data, UITabBarController")
        
        createProject(index: 8, title: "7 Swifty Words", subTitle: "addTarget(), enumerated(), count, index(of:), property observers, range operators")
    }
    
    
    func createProject(index: Int, title: String, subTitle: String)
    {
        let proj = Project(title: "Project \(index): \(title)", subTitle: subTitle)
        projects.append(proj)
    }
}
