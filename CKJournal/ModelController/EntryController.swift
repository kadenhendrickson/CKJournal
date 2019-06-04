//
//  EntryController.swift
//  CKJournal
//
//  Created by Kaden Hendrickson on 6/3/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {

    //Singleton
    static let shared = EntryController()
    
    //Source Of Truth
    var entries: [Entry] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //CRUD
        //Create
    func createEntry(title: String, text: String) {
        let entry = Entry(title: title, text: text)
        self.saveEntries(entry: entry) { (_) in}
    }
        //Delete
    func deleteEntry(entry: Entry, completion: @escaping (Bool) -> ()) {
        guard let index = EntryController.shared.entries.firstIndex(of: entry) else {return}
        EntryController.shared.entries.remove(at: index)
        
        privateDB.delete(withRecordID: entry.ckRecordID) { (_, error) in
            if let error = error {
                print("😝 There was an error in \(#function) : \(error) : \(error.localizedDescription) 😝")
                completion(false)
                return
            } else {
                print("you're cool")
                completion(true)
            }
    }
}
    
    //Save Entries
    func saveEntries(entry: Entry, completion: @escaping (Bool) -> Void) {
       
        let entryRecord = CKRecord(entry: entry)
        privateDB.save(entryRecord) { (record, error) in
            if let error = error {
                print("😝 There was an error in \(#function) : \(error) : \(error.localizedDescription) 😝")
                completion(false)
                return
            } else {
                print("Entry saved!")
            }
            guard let record = record, let entry = Entry(ckRecord: record) else {return}
            self.entries.append(entry)
            completion(true)
        }
    }
    
    //Load Entries
    func fetchEntries(completion: @escaping (Bool) -> ()) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.recordKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("😝 There was an error in \(#function) : \(error) : \(error.localizedDescription) 😝")
                completion(false)
                return
        }
            guard let records = records else {completion(false); return}
            let entriesArray = records.compactMap({Entry(ckRecord: $0)})
            self.entries = entriesArray
            completion(true)
            
    }
}
}

