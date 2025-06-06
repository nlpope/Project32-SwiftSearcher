//  File: HomeVC.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import UIKit
import AVKit
import AVFoundation
import SafariServices

class HomeVC: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating
{
    enum Section { case main }
    
    var dataSource: UITableViewDiffableDataSource<Section, SSProject>!
    var projects = [SSProject]()
    var filteredProjects = [SSProject]()
    var isSearching = false
    var editModeOn = false
    var logoLauncher: SSLogoLauncher!
    var player = AVPlayer()
    let baseURL = "https://www.hackingwithswift.com/read/"
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        PersistenceManager.isFirstVisitStatus = true
        configNavigation()
        configSearchController()
        configDiffableDataSource()
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
            let cellTitle = project.title == "" ? "Untitled" : project.title
            let cellSubtitle = project.subtitle == "" ? "" : project.subtitle
            let cellSkillList = project.skills == "" ? "" : project.skills
                        
            cell.textLabel?.attributedText = self.makeAttributedString(title: cellTitle, subtitle: cellSubtitle, skills: cellSkillList)
            return cell
        }
    }
    
    //-------------------------------------//
    // MARK: - CELL ATTRIBUTED STRINGS
    
    func makeAttributedString(title: String, subtitle: String, skills: String) -> NSAttributedString
    {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        let skillsAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: "\(subtitle)\n", attributes: subtitleAttributes)
        let skillsString = NSAttributedString(string: skills, attributes: skillsAttributes)
        
        titleString.append(subtitleString)
        titleString.append(skillsString)
        return titleString
    }
    
    //-------------------------------------//
    // MARK: - PROJECT CREATION, APPENDING, & EDITING
    
//    func createProjects()
//    {
//        createProject(title: "Storm Viewer", subtitle: "Constants & variables, UITableView, UIImageViw, FileManager, storyboards", index: 1)
//
//        createProject(title: "Guess the Flag", subtitle: "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController", index: 2)
//        
//        createProject(title: "Social Media", subtitle: "UIBarButtonItem, UIActivityViewController, the Social framework, URL", index: 3)
//        
//        createProject(title: "Easy Browser", subtitle: "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView, key-value observing", index: 4)
//        
//        createProject(title:"Word Scramble", subtitle: "Closures, method return values, booleans, NSRange", index: 5)
//        
//        createProject(title: "Auto Layout", subtitle: "Get to grips with Auto Layout using practical examples and code", index: 6)
//        
//        createProject(title: "Whitehouse Petitions", subtitle: "JSON, Data, UITabBarController", index: 7)
//        
//        createProject(title: "7 Swifty Words", subtitle: "addTarget(), enumerated(), count, index(of:), property observers, range operators", index: 8)
//    }
    
    
//    func createProject(title: String, subtitle: String, skills: String, index: Int)
//    {
//        let proj = SSProject(title: "Project \(index): \(title)", subtitle: subtitle, skills: skills, index: index)
//        projects.append(proj)
//        PersistenceManager.updateProjectsWith(project: proj, actionType: .add) { [weak self] error in
//            guard let error = error else { return }
//            self?.presentSSAlertOnMainThread(alertTitle: "Failed to save project", message: error.rawValue, buttonTitle: "Ok")
//        }
//        updateDataSource(with: projects)
//    }
    
    //-------------------------------------//
    // MARK: - TABLEVIEW METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
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
            || $0.subtitle.lowercased().contains(desiredFilter.lowercased())
            || $0.index.description.contains(desiredFilter)
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
        NetworkManager.shared.fetchProjects { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let projects):
                self.projects = projects; self.updateDataSource(with: projects)
            case .failure(let error):
                self.presentSSAlertOnMainThread(alertTitle: "Fetch Fail", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        
        
//        PersistenceManager.fetchProjects { [weak self] result in
//            switch result {
//            case .success(let projects):
//                if projects.count == 0 { self?.createProjects() }
//                else { self?.projects = projects; self?.updateDataSource(with: projects) }
//            case .failure(let error):
//                self?.presentSSAlertOnMainThread(alertTitle: "Load failed", message: error.rawValue, buttonTitle: "Ok")
//            }
//        }
    }
    
    
    func updateDataSource(with projects: [SSProject])
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SSProject>()
        snapshot.appendSections([.main])
        snapshot.appendItems(projects)
        
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}
