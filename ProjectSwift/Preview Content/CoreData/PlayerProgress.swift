//
//  PlayerProgress.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 28/03/25.
//

import Foundation
import CoreData

@objc(PlayerProgress)
public class PlayerProgress: NSManagedObject {}

extension PlayerProgress {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerProgress> {
        return NSFetchRequest<PlayerProgress>(entityName: "PlayerProgress")
    }

    @NSManaged public var score: Int64
    @NSManaged public var lives: Int64
    @NSManaged public var levelOneStars: Int64
    @NSManaged public var levelTwoStars: Int64
}

