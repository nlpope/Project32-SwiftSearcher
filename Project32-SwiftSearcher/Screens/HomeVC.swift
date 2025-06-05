//  File: HomeVC.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import UIKit
import AVKit
import AVFoundation

class HomeVC: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating
{
    enum Section { case main }
    
    var dataSource: UITableViewDiffableDataSource<Section, SSProject>!
    var projects = [SSProject]()
    var filteredProjects = [SSProject]()
    var addButton: UIBarButtonItem!
    var logoLauncher: SSLogoLauncher!
    var player = AVPlayer()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        PersistenceManager.isFirstVisitStatus = true
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        logoLauncher = SSLogoLauncher(targetVC: self)
        if PersistenceManager.fetchFirstVisitStatus() {
            logoLauncher.configLogoLauncher()
        } else {
            fetchProjects()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) { logoLauncher = nil }
    
    
    deinit { logoLauncher.removeAllAVPlayerLayers() }
    
    //-------------------------------------//
    // MARK: - CONFIGURATION
    
    func configNavigation()
    {
        view.backgroundColor = .systemBackground
        title = "Projects"
        navigationController?.navigationBar.prefersLargeTitles = true
        addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationController?.navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configSearchController()
    {
        let mySearchController = UISearchController()
        mySearchController.searchResultsUpdater = self
        mySearchController.searchBar.delegate = self
        mySearchController.searchBar.placeholder = "Search projects"
        mySearchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = mySearchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func configDiffableDataSource()
    {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, project in
            let cell = tableView.dequeueReusableCell(withIdentifier: "SSCell", for: indexPath)
            cell.textLabel?.text = project.title == "" ? "Untitled" : project.title
            cell.detailTextLabel?.text = project.subTitle == "" ? "" : project.subTitle
            return cell
        }
    }
    
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
        PersistenceManager.updateProjectsWith(project: proj, actionType: .add) { [weak self] error in
            guard let error = error else { return }
            self?.presentSSAlertOnMainThread(alertTitle: "Failed to save project", message: error.rawValue, buttonTitle: "Ok")
        }
        updateDataSource(with: projects)
    }
    
    
    @objc func addButtonTapped()
    {
        print("add tapped")
    }
    
    //-------------------------------------//
    // MARK: - TABLEVIEW METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("row selected")
    }
    
    //-------------------------------------//
    // MARK: - SEARCH CONTROLLER METHODS
    
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let desiredFilter = searchController.searchBar.text, !desiredFilter.isEmpty
        else { return }
        filteredProjects = projects.filter {
            $0.title.lowercased().contains(desiredFilter.lowercased())
            || $0.subTitle.lowercased().contains(desiredFilter.lowercased())
        }
        updateDataSource(with: filteredProjects)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    { searchBar.resignFirstResponder(); updateDataSource(with: projects) }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    { if searchText == "" { updateDataSource(with: projects) } }
    
    //-------------------------------------//
    // MARK: - PROJECT PERSISTENCE & DIFFABLE DATASOURCE UPDATES
    
    func fetchProjects()
    {
        PersistenceManager.fetchProjects { [weak self] result in
            switch result {
            case .success(let projects):
                if projects.count == 0 { self?.createProjects() }
                else { self?.projects = projects; self?.updateDataSource(with: projects) }
            case .failure(let error):
                self?.presentSSAlertOnMainThread(alertTitle: "Load failed", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func updateDataSource(with projects: [SSProject])
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SSProject>()
        snapshot.appendSections([.main])
        snapshot.appendItems(projects)
        
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}
