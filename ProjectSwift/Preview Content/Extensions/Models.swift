//
//  Balloon.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 12/03/25.
//

import SwiftUI

struct Balloon: Identifiable {
    var id: UUID = UUID()
    var position: CGPoint
    var imageName: String
    var isPopped: Bool = false
    var speed: CGFloat
    var isBad: Bool
    var rotation: Double 
    var size: CGFloat
}

struct PickupItem: Identifiable {
    var id = UUID()
    var imageName: String
    var position: CGPoint
}



