//
//  Milestone.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI
import RealmSwift

class Milestone: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var descriptionMilestone: String
    @Persisted var milestoneImage: Data?
    
    convenience init(
        title: String,
        descriptionMilestone: String,
        milestoneImage: Data
    ) {
            
            self.init()
            self.title = title
            self.descriptionMilestone = descriptionMilestone
            self.milestoneImage = milestoneImage
    }
    
}
