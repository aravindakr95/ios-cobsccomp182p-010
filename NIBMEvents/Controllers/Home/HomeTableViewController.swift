//
//  HomeTableViewController.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

import Firebase
import SVProgressHUD
import RxSwift

class HomeTableViewController: UITableViewController {
    let disposeBag: DisposeBag = DisposeBag()
    var isGuest: Bool?
    
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnAddEvent: UIBarButtonItem!
    
    var eventsData: [Event] = [Event]()
    var currentIndex: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.isGuest = UserDefaults.standard.bool(forKey: "isGuest")
        self.btnBack.isEnabled = isGuest!
        self.btnAddEvent.isEnabled = !isGuest!
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show(withStatus: "Loading Events")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureStyles()
        self.fetchPosts()
        self.listenUpdateEvents()
        self.updateEventPreference()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        SVProgressHUD.dismiss()
    }
    
    @IBAction func onGoBack(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(false, forKey: "isGuest")
        self.transition(identifier: "unwindToInitial")
    }
    
    @IBAction func onAddEvent(_ sender: UIBarButtonItem) {
        self.transition(identifier: "homeToAddEvent")
    }
    
    @objc private func publisherProfileImageTapped() {
        guard let index = self.currentIndex else { return }
        let selectedEvent = self.eventsData[index]
        let publisher: [String: String] =  [
            "publisher": selectedEvent.publisher!,
            "publisherBatch": selectedEvent.publisherBatch!,
            "publisherFacebookIdentifier": selectedEvent.publisherFacebookIdentifier!,
            "publisherImageUrl": selectedEvent.publisherImageUrl!,
            "publisherContactNumber": selectedEvent.publisherContactNumber!
        ]
        
        UserDefaults.standard.set(publisher, forKey: "selectedProfile")
        self.transition(identifier: "homeToPublisherProfile")
    }
    
    @objc private func eventImageTapped() {
        guard let index = self.currentIndex else { return }
        let selectedEvent = self.eventsData[index]
        
        let customEvent: [String: Any] =  [
            "documentId": selectedEvent.documentId!,
            "title": selectedEvent.title,
            "body": selectedEvent.body,
            "publishedLocation": selectedEvent.publishedLocation!,
            "longitude": selectedEvent.coordinates?.longitude,
            "latitude": selectedEvent.coordinates?.latitude,
            "publisherName": selectedEvent.publisher!,
            "publisherImageUrl": selectedEvent.publisherImageUrl!,
            "publisherContactNumber": selectedEvent.publisherContactNumber!,
            "eventImageUrl": selectedEvent.eventImageUrl,
            "timeStamp": Date(),
        ]
        
        UserDefaults.standard.set(customEvent, forKey: "selectedEvent")
        self.transition(identifier: "homeToEvent")
    }
    
    private func configureStyles() {
        self.tableView.estimatedRowHeight = TableViewIdentifiers.postCellDefaultHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorColor = UIColor.clear
    }
    
    private func fetchPosts() {
        DatabaseManager.sharedInstance.retrieveDocuments(collection: "events") { [weak self] (events, error) in
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
    
    private func updateEventPreference() {
        EventBodyCell.onEventPreferenceChange.subscribe(onNext: { [weak self] preference in
            guard let `self` = self else { return }
            guard let index = self.currentIndex else { return }
            
            let docId = self.eventsData[index].documentId
            
            DatabaseManager.sharedInstance.mergeDocument(collection: "events",
                                                         documentId: docId!,
                                                         data: ["isGoing": preference]) { (success, error) in
                                                            if error != nil {
                                                                print(error!)
                                                            } else {
                                                                print(success!)
                                                            }
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func listenUpdateEvents() {
        DatabaseManager.sharedInstance.listenDocumentsChange(collection: "events") { [weak self] (event, error) in
            guard let `self` = self else { return }
            
            guard let event = event else {
                print("Error fetching events: \(error!)")
                return
            }
            
            if let row = self.eventsData.firstIndex(where: {$0.documentId == event.documentId}) {
                self.eventsData[row] = event
            } else {
                self.eventsData.append(event)
            }
            
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

extension HomeTableViewController {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifiers.eventBodyCell, for: indexPath) as? EventBodyCell
        self.currentIndex = indexPath.section
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventImageTapped))
        cell!.imgPostView.isUserInteractionEnabled = true
        cell!.imgPostView.addGestureRecognizer(tapGesture)
        
        cell!.event = self.eventsData[indexPath.section]
        cell!.selectionStyle = .none
        cell!.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 0.8470588235)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            TableViewIdentifiers.eventHeaderCell) as? EventHeaderCell
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(publisherProfileImageTapped))
        cell!.imgProfileView.isUserInteractionEnabled = true
        cell!.imgProfileView.addGestureRecognizer(tapGesture)
        
        cell!.event = self.eventsData[section]
        cell!.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableViewIdentifiers.postHeaderHeight
    }
}
