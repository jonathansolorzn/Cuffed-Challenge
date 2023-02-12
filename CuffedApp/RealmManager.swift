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
    
    init(name: String) {
        initializeSchema(name: name)
    }
    
    func initializeSchema(name: String) {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let realmFileUrl = docDir.appendingPathComponent("\(name).realm")
        let config = Realm.Configuration(fileURL: realmFileUrl, schemaVersion: 1) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: Profileinfo.className()) { _, newObject in
                    newObject!["flag"] = "🏳️"
                }
                migration.enumerateObjects(ofType: MilestoneData.className()) { _, newObject in
                    newObject!["flag"] = "🏳️"
                }
            }
        }
        Realm.Configuration.defaultConfiguration = config
        print(docDir.path)
        do {
            realm = try Realm()
        } catch {
            print("Error opening default realm", error)
        }
        
    }
    
    func elimanteLastObject() {
        do {
            let realm = try Realm()
            
            try realm.write {
                let profile = realm.objects(Profileinfo.self)
                realm.delete(profile)
            }
        } catch let error {
            print(error.localizedDescription)
        }
       
    }

}
