//
//  RealmManager.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    
    private(set) var realm: Realm?
    
    init() {
        
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        
        do {
            let realmFile = try Realm()
            
            if let congFileURL = config.fileURL {
                let fileURL = try schemaVersionAtURL(congFileURL)
            }
        } catch {
            print(error)
        }
    }
    
    func elimanteLastObject() {
        do {
            let realm = try Realm()
            
            try realm.write {
                let profile = realm.objects(Profile.self)
                realm.delete(profile)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
