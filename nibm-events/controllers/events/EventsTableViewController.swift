//
//  EventsTableViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/25/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift

class EventsTableViewController: UITableViewController {
    let disposeBag: DisposeBag = DisposeBag()
    var eventsData: [Event] = [Event]()
    var currentIndex: Int?
    
    struct Storyboard {
        static let myEventCell = "MyEventBodyCell"
        static let myEventHeaderCell = "MyEventHeaderCell"
        static let postHeaderHeight: CGFloat = 57.0
        static let postCellDefaultHeight: CGFloat = 578.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show(withStatus: "Loading Events")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
        self.fetchPosts()
        self.listenUpdateEvents()
        self.openEditEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        SVProgressHUD.dismiss()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(type(of: segue.destination))
        if (segue.identifier == "eventsToEditEvent") {
            guard let index = self.currentIndex else { return }
            let editEventVC = self.storyboard?.instantiateViewController(withIdentifier: "EditEventVC")
                as? EditEventViewController
            
            editEventVC!.event = self.eventsData[index]
        }
    }
    
    private func openEditEvent() {
        MyEventHeaderCell.onEditPreferenceChange.subscribe(onNext: { [weak self] data in
            guard let `self` = self else { return }
            if data != "" {
                self.transition(identifier: "eventsToEditEvent")
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func configureStyles() {
        self.tableView.estimatedRowHeight = Storyboard.postCellDefaultHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorColor = UIColor.clear
    }
    
    private func fetchPosts() {
        guard let userProfile = AuthManager.sharedInstance.user
            else { return }
        DatabaseManager.sharedInstance.retrieveDocumentsWhere(finder: "uid",
                                                              value: userProfile.uid,
                                                              collection: "events")
        { [weak self] (events, error) in
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
        guard let userProfile = AuthManager.sharedInstance.user
            else { return }
        
        DatabaseManager.sharedInstance.listenDocumentChangeWhere(finder: "uid",
                                                                 value: userProfile.uid,
                                                                 collection: "events")
        { [weak self] (event, error) in
            guard let `self` = self else { return }
            
            guard let event = event else {
                print("Error fetching events: \(error!)")
                return
            }
            
            self.eventsData.append(event)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func transition(identifier: String) {
        DispatchQueue.main.async {
            TransitionManager.sharedInstance.transitionSegue(sender: self, identifier: identifier)
        }
    }
}

extension EventsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !self.eventsData.isEmpty {
            return self.eventsData.count
        } else { return 0 }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.eventsData.isEmpty {
            return 1
        } else { return 0 }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.myEventCell, for: indexPath) as! MyEventBodyCell
        cell.event = self.eventsData[indexPath.section]
        cell.selectionStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 0.8470588235)
        
        self.currentIndex = indexPath.section
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.myEventHeaderCell) as! MyEventHeaderCell
        
        cell.event = self.eventsData[section]
        cell.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.postHeaderHeight
    }
    
}
