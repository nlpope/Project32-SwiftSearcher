//  File: HomeVC.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import UIKit
import AVKit
import AVFoundation
import SafariServices

class HomeVC: SSDataLoadingVC, UISearchBarDelegate, UISearchResultsUpdating
{
    enum Section { case main }
    
    var dataSource: UITableViewDiffableDataSource<Section, SSProject>!
    var projects = [SSProject]()
    var filteredProjects = [SSProject]()
    var isSearching = false
    var favorites = [SSProject]()
    var editModeOn = false {
        didSet {
            tableView.isEditing = editModeOn ? true : false
            updateDataSource(with: projects)
            configNavigation()
        }
    }
    
    var logoLauncher: SSLogoLauncher!
    var player = AVPlayer()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        PersistenceManager.isFirstVisitStatus = true
        configNavigation()
        configSearchController()
        configTableView()
        configDiffableDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        logoLauncher = SSLogoLauncher(targetVC: self)
        editModeOn = false
        if PersistenceManager.fetchFirstVisitStatus() { logoLauncher.configLogoLauncher() }
        else { fetchProjects(); fetchFavorites() }
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
        
        if editModeOn {
            let editItem = UIBarButtonItem(barButtonSystemItem: .done,
                                           target: self,
                                           action: #selector(toggleEditMode))
            navigationItem.rightBarButtonItem = editItem
        } else {
            let editItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                           target: self,
                                           action: #selector(toggleEditMode))
            navigationItem.rightBarButtonItem = editItem
        }
        
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
    
    
    func configTableView()
    {
        tableView.allowsSelectionDuringEditing = true
    }
    
    
    func configDiffableDataSource()
    {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, project in
            let cell = tableView.dequeueReusableCell(withIdentifier: "SSCell", for: indexPath)
            
            let cellTitle = project.title == "" ? "Untitled" : "Project \(project.index) \(project.title)"
            let cellSubtitle = project.subtitle == "" ? "" : project.subtitle
            let cellSkillList = project.skills == "" ? "" : project.skills
                        
            // contin. @ tableView delegate sect > tableView(_:editingStyleForRowAt:)
            if self.favorites.contains(project) { cell.editingAccessoryType = .checkmark }
            else { cell.editingAccessoryType = .none }
            
            cell.textLabel?.attributedText = self.makeAttributedString(title: cellTitle, subtitle: cellSubtitle, skills: cellSkillList)
            
            return cell
        }
    }
    
    //-------------------------------------//
    // MARK: - ATTRIBUTED STRING CREATION
    
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
    // MARK: - NETWORK CALLS
    
    func fetchProjects()
    {
        showLoadingView()
        NetworkManager.shared.fetchProjects { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let projects):
                self.projects = projects; self.updateDataSource(with: projects)
            /**--------------------------------------------------------------------------**/
            case .failure(let error):
                self.presentSSAlertOnMainThread(alertTitle: "Fetch Fail", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    //-------------------------------------//
    // MARK: - SEARCH CONTROLLER METHODS
    
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let desiredFilter = searchController.searchBar.text, !desiredFilter.isEmpty
        else { return }
        isSearching = true
        filteredProjects = projects.filter {
            $0.title.lowercased().contains(desiredFilter.lowercased())
            || $0.subtitle.lowercased().contains(desiredFilter.lowercased())
            || $0.skills.lowercased().contains(desiredFilter.lowercased())
            || $0.index.description.contains(desiredFilter)
        }
        updateDataSource(with: filteredProjects)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    { searchBar.resignFirstResponder(); isSearching = false; updateDataSource(with: projects) }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText == "" { isSearching = false; updateDataSource(with: projects) }
        else { isSearching = true }
    }
    
    //-------------------------------------//
    // MARK: - EDIT MODE (ADD/REMOVE FAVORITES)
    
    @objc func toggleEditMode() { editModeOn.toggle() }
    
    //-------------------------------------//
    // MARK: - DIFFABLE DATASOURCE UPDATES
    
    func updateDataSource(with projects: [SSProject])
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SSProject>()
        snapshot.appendSections([.main])
        snapshot.appendItems(projects)
        
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    //-------------------------------------//
    // MARK: - TABLEVIEW DELEGATE METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let activeArray = isSearching ? filteredProjects : projects
        tableView.deselectRow(at: indexPath, animated: true)
        showTutorial(activeArray[indexPath.row].index)
    }
    
    
    // contin. from configDiffableDataSource > cell.editingAccessoryType
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        let currentProject = projects[indexPath.row]
        if favorites.contains(currentProject) { return .delete }
        else { return .insert }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let currentProject = projects[indexPath.row]
        if editingStyle == .insert { favorites.append(currentProject) }
        else { favorites.removeAll { $0.title == currentProject.title } }
    }
    
    //-------------------------------------//
    // MARK: - SAFARI PRESENTATION METHODS
    
    func showTutorial(_ which: Int)
    {
        if let url = URL(string: "\(URLKeys.baseURL)\(which)") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH
    
    func fetchFavorites()
    {
        PersistenceManager.fetchFavorites { result in
            switch result {
            case .success(let savedFavorites):
                self.favorites = savedFavorites
            case .failure(let error):
                self.presentSSAlertOnMainThread(alertTitle: "Failed to load favorites", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
