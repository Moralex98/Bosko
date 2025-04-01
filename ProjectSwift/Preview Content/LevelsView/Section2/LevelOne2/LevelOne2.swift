//
//  LevelOne2.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 31/03/25.
//

import SwiftUI

struct LevelOne2: View {
    private var fourColumnGrid = Array(repeating: GridItem(.flexible(), spacing: 20), count: 4)
    private var sixColumnGrid = Array(repeating: GridItem(.flexible(), spacing: 15), count: 6)

    @State var cards = createCardList().shuffled()
    @State var MatchedCards: [Card] = []
    @State var userChoices: [Card] = []

    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()

            GeometryReader { geo in
                VStack(spacing: 40) {
                    Text("🌊 Ocean Memory 🌊")
                        .font(.system(size: 48, weight: .bold))

                    LazyVGrid(columns: fourColumnGrid, spacing: 25) {
                        ForEach(cards) { card in
                            CardView(
                                card: card,
                                width: Int(geo.size.width / 5),
                                MatchedCards: $MatchedCards,
                                userChoices: $userChoices
                            )
                        }
                    }
                    .padding(.horizontal, 40)

                    VStack(spacing: 10) {
                        Text("Match these cards to win")
                            .font(.title2)

                        LazyVGrid(columns: sixColumnGrid, spacing: 10) {
                            ForEach(cardValues, id: \.self) { cardValue in
                                if !MatchedCards.contains(where: { $0.text == cardValue }) {
                                    Text(cardValue)
                                        .font(.system(size: 36))
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.horizontal, 60)
                    }
                }
                .padding(.top, 60)
            }
        }
    }
}

#Preview {
    LevelOne2()
}
