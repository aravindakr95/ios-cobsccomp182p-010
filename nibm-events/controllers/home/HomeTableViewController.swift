//
//  HomeTableViewController.swift
//  nibm-events
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
    
    struct Storyboard {
        static let eventCell = "EventBodyCell"
        static let eventHeaderCell = "EventHeaderCell"
        static let postHeaderHeight: CGFloat = 57.0
        static let postCellDefaultHeight: CGFloat = 578.0
    }
    
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
        
        UserDefaults.standard.set(publisher, forKey: "selectedEvent")
        self.transition(identifier: "homeToPublisherProfile")
    }
    
    private func configureStyles() {
        self.tableView.estimatedRowHeight = Storyboard.postCellDefaultHeight
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
                                                         data: ["isGoing": preference]) { [weak self] (success, error) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.eventCell, for: indexPath) as! EventBodyCell
        cell.event = self.eventsData[indexPath.section]
        cell.selectionStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 0.8470588235)
        
        self.currentIndex = indexPath.section
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.eventHeaderCell) as! EventHeaderCell
        cell.imgProfileView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(publisherProfileImageTapped))
        cell.imgProfileView.addGestureRecognizer(tapGesture)
        
        cell.event = self.eventsData[section]
        cell.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.postHeaderHeight
    }
}
