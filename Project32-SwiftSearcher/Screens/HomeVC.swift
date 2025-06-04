//  File: HomeVC.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import UIKit

class HomeVC: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating
{
    enum Section { case main }
    
    var dataSource: UITableViewDiffableDataSource<Section, SSProject>!
    var projects = [SSProject]()
    var filteredProjects = [SSProject]()
    var addButton: UIBarButtonItem!
    var logoLauncher: 
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createProjects()
    }
    
    
    deinit { logoLauncher.removeAllAVPlayerLayers() }
    
    //-------------------------------------//
    // MARK: - PROJECT CREATION & APPENDING
    
    func createProjects()
    {
        createProject(title: "Storm Viewer", subTitle: "Constants & variables, UITableView, UIImageViw, FileManager, storyboards", index: 1)

        createProject(title: "Guess the Flag", subTitle: "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController", index: 2)
        
        createProject(title: "Social Media", subTitle: "UIBarButtonItem, UIActivityViewController, the Social framework, URL", index: 3)
        
        createProject(title: "Easy Browser", subTitle: "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView, key-value observing", index: 4)
        
        createProject(title:"Word Scramble", subTitle: "Closures, method return values, booleans, NSRange", index: 5)
        
        createProject(title: "Auto Layout", subTitle: "Get to grips with Auto Layout using practical examples and code", index: 6)
        
        createProject(title: "Whitehouse Petitions", subTitle: "JSON, Data, UITabBarController", index: 7)
        
        createProject(title: "7 Swifty Words", subTitle: "addTarget(), enumerated(), count, index(of:), property observers, range operators", index: 8)
    }
    
    
    func createProject(title: String, subTitle: String, index: Int)
    {
        let proj = SSProject(title: "Project \(index): \(title)", subTitle: subTitle, index: index)
        projects.append(proj)
    }
    
    //-------------------------------------//
    // MARK: - TABLEVIEW DATASOURCE & DELEGATE METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return projects.count
    }
    
    
}
