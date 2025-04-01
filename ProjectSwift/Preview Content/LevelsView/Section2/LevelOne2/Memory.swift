//
//  Memory.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 31/03/25.
//

import Foundation
import SwiftUI

class Card: Identifiable, ObservableObject {
    var id = UUID()
    @Published var isFaceUP  = false
    @Published var isMatched = false
    var text: String
    
    init (text: String){
        self.text = text
    }
    
    func tunrOver(){
        self.isFaceUP.toggle()
    }
}

let cardValues: [String] = [
 "🦑", "🦐", "🦞", "🐡", "🦀", "🐠", "🐟", "🐬", "🐳", "🦭", "🐊", "🐙"
]

func createCardList() -> [Card] {
    //create a blank list
    var cardList = [Card]()
    
    for cardValue in cardValues {
        cardList.append(Card(text: cardValue))
        cardList.append(Card(text: cardValue))
    }
    return cardList
}

let faceDownCard = Card(text: "?")

