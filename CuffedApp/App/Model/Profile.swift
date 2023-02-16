//
//  Profile.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import Foundation
import RealmSwift

class Profile: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var userAge: Int
    @Persisted var bioDescription: String
    @Persisted var pictureProfile: Data
    
    convenience init(
        name: String,
        userAge: Int,
        bioDescription: String,
        pictureProfile: Data
    ) {
            self.init()
            self.name = name
            self.userAge = userAge
            self.bioDescription = bioDescription
            self.pictureProfile = pictureProfile
    }
}
