//
//  CardView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 31/03/25.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var card: Card
    let width: Int

    @Binding var MatchedCards: [Card]
    @Binding var userChoices: [Card]
    
    var body: some View {
        if card.isFaceUP || MatchedCards.contains(where: {$0.id == card.id}){
            Text(card.text)
            .font(.system(size: 50))
            .padding()
            .frame(width: CGFloat(width), height: CGFloat(width))
            .background(Color(red: 0.68, green: 0.83, blue: 0.96))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.18, green: 0.32, blue: 0.46), lineWidth: 5)
                
            )
        } else {
            Text("?")
                .font(.system(size: 50))
                .padding()
                .frame(width: CGFloat(width), height: CGFloat(width))
                .background(Color(red: 0.68, green: 0.83, blue: 0.96))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.18, green: 0.32, blue: 0.46), lineWidth: 5)
                    
                )
                .onTapGesture {
                    if userChoices.count == 0 {
                        card.tunrOver()
                        userChoices.append(card)
                    } else if userChoices.count == 1 {
                        card.tunrOver()
                        userChoices.append(card)
                        withAnimation(Animation.linear.delay(1)){
                            for thisCard in userChoices{
                                thisCard.tunrOver()
                            }
                        }
                        checkForMatch()
                    }
                }
        }
    }
    
    func checkForMatch(){
        if userChoices [0].text == userChoices[1].text {
            MatchedCards.append(userChoices[0])
            MatchedCards.append(userChoices[1])
        }
        userChoices.removeAll()
    }
}
