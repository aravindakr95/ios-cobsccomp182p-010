//
//  MyEventHeaderCell.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/28/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import RxSwift

class MyEventHeaderCell: UITableViewCell {
    @IBOutlet weak var lblEventName: UILabel!
//    @IBOutlet weak var lblEventLocation: UILabel!
    
    private static let editPreference: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    static var onEditPreferenceChange: Observable<String> {
        return MyEventHeaderCell.editPreference.asObservable()
    }
    
    var event: Event! {
        didSet {
            self.updateUI()
        }
    }

    @IBAction func onEditEvent(_ sender: UIButton) {
        guard let docId = event.documentId else { return }
        MyEventHeaderCell.editPreference.onNext(docId)
    }
    
    private func updateUI() {
        guard let event = event else { return }
        self.lblEventName.text = event.title
    }
}
