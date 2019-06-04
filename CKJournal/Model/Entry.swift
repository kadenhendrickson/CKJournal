//
//  Entry.swift
//  CKJournal
//
//  Created by Kaden Hendrickson on 6/3/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    static let recordKey = "Entry"
    static let titleKey = "title"
    static let textKey = "text"
    static let timestampKey = "timestamp"
}

class Entry {
    let title: String
    let text: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init(title: String, text: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.title = title
        self.text = text
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[Constants.titleKey] as? String,
            let text = ckRecord[Constants.textKey] as? String,
            let timestamp = ckRecord[Constants.timestampKey] as? Date else {return nil}
        
        self.init(title: title, text: text, timestamp: timestamp, ckRecordID: ckRecord.recordID)
        
    }
}

extension CKRecord {

    convenience init(entry: Entry) {
        self.init(recordType: Constants.recordKey, recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: Constants.titleKey)
        self.setValue(entry.text, forKey: Constants.textKey)
        self.setValue(entry.timestamp, forKey: Constants.timestampKey)
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return rhs.title == lhs.title && rhs.text == lhs.text && rhs.timestamp == lhs.timestamp
    }
    
    
}
