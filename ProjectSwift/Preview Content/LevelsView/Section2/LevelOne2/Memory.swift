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
    var imageName: String
    
    init (imageName: String){
        self.imageName = imageName
    }
    
    func tunrOver(){
        self.isFaceUP.toggle()
    }
}

let cardValues = [
 "cocopares", "cotorra", "iguanapar", "monitopares", "serppares", "tapirpar"
]

func createCardList() -> [Card] {
    //create a blank list
    var cardList = [Card]()
    
    for cardValue in cardValues {
        cardList.append(Card(imageName: cardValue))
        cardList.append(Card(imageName: cardValue))
    }
    return cardList
}

let faceDownCard = Card(imageName: "imagen1")

