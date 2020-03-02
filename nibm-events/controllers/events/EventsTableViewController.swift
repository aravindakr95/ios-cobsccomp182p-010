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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show(withStatus: "Loading Your Events")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
        self.fetchPosts()
        self.listenUpdateEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        SVProgressHUD.dismiss()
    }
    
    @objc private func editButtonTapped() {
        guard let index = self.currentIndex else { return }
        let selectedEvent = self.eventsData[index]

        let data: [String: String] = [
            "documentId": selectedEvent.documentId!,
            "publishedLocation": selectedEvent.publishedLocation!,
            "publisherContactNumber": selectedEvent.publisherContactNumber!,
            "title": selectedEvent.title,
            "body": selectedEvent.body,
            "eventImageUrl": selectedEvent.eventImageUrl
        ]

        let sendData = CustomEvent(event: data)
        UserDefaults.standard.set(data, forKey: "eventData")
        self.transition(identifier: "eventsToEditEvent")
    }

    private func configureStyles() {
        self.tableView.estimatedRowHeight = TableViewIdentifiers.postCellDefaultHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorColor = UIColor.clear
    }

    private func fetchPosts() {
        guard let userProfile = AuthManager.sharedInstance.user
            else { return }
        DatabaseManager.sharedInstance.retrieveDocumentsWhere(finder: "uid",
                                                              value: userProfile.uid,
                                                              collection: "events") { [weak self] (events, error) in
            guard let `self` = self else { return }
            guard let events = events else {
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
                                                                 collection: "events") { [weak self] (event, error) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifiers.myEventBodyCell, for: indexPath) as! MyEventBodyCell
        cell.event = self.eventsData[indexPath.section]
        cell.selectionStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 0.8470588235)

        self.currentIndex = indexPath.section
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifiers.myEventHeaderCell) as! MyEventHeaderCell

        cell.event = self.eventsData[section]
        cell.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editButtonTapped))
        cell.btnEditEvent.addGestureRecognizer(tapGesture)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableViewIdentifiers.postHeaderHeight
    }

}
