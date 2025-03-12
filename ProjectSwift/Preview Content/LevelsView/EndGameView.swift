//
//  EndGameView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 12/03/25.
//

import SwiftUI

struct MenuView: View {
    @State var score: Int // Puntuación acumulada
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                Text("Menú Principal")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding(.top, 50)
                
                Spacer()
                
                Button(action: {
                    // Aquí podrías agregar navegación a otras opciones
                }) {
                    Text("Opción 1")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Spacer()
            }
            
            //Mostrar el marcador en la esquina superior derecha
            ScoreView(score: $score)
                .offset(x: UIScreen.main.bounds.width / 2 - 100, y: -UIScreen.main.bounds.height / 2 + 50)
        }
    }
}


#Preview {
    MenuView(score: 100)
}
