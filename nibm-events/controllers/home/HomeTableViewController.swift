//
//  HomeTableViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewController: UITableViewController {
    let databaseManager = DatabaseManager()
    var activityIndicator: UIAlertController?
    
    var eventsData: [Event] = [Event]()
    
    struct Storyboard {
        static let eventCell = "EventBodyCell"
        static let eventHeaderCell = "EventHeaderCell"
        static let postHeaderHeight: CGFloat = 57.0
        static let postCellDefaultHeight: CGFloat = 578.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchPosts()
        self.listenUpdateEvents()
        
        tableView.estimatedRowHeight = Storyboard.postCellDefaultHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.clear
    }
    
    @IBAction func onAddEvent(_ sender: UIBarButtonItem) {
        self.transitionToAddEvent()
    }
    
    private func fetchPosts() {
        self.databaseManager.retrieveDocuments(collection: "events") { [weak self] (events, error) in
            guard let `self` = self else { return }

            guard let events = events else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            
            self.eventsData = events
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func listenUpdateEvents() {
        self.databaseManager.listenDocumentChanges(collection: "events") { [weak self] (event, error) in
            guard let `self` = self else { return }
            
            guard let event = event else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            
            self.eventsData.append(event)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func transitionToAddEvent() {
        DispatchQueue.main.async {
            TransitionManager.transitionSegue(sender: self, identifier: "homeToAddEvent")
        }
    }
}

extension HomeTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return eventsData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.eventCell, for: indexPath) as! EventBodyCell
        
        cell.event = self.eventsData[indexPath.section]
        cell.selectionStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 0.8470588235)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.eventHeaderCell) as! EventHeaderCell
        
        cell.event = self.eventsData[section]
        cell.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.postHeaderHeight
    }
}
