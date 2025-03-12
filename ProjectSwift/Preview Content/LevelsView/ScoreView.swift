//
//  ScoreView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 12/03/25.
//

import SwiftUI

struct ScoreView: View {
    @Binding var score: Int // Recibe el puntaje desde GameView
    
    var body: some View {
        Text("Puntuación: \(Text("\(score)").foregroundColor(.orange))")
            .font(.custom("Bebas Neue", size: 25))
            .foregroundColor(.red)
    }
}

#Preview {
    @State var sampleScore = 10
    return ScoreView(score: $sampleScore)
}



