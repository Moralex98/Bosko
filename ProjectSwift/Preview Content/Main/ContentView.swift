//
//  ContentLevek.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 08/03/25.
//

import SwiftUI

struct ContentView: View {
    private let xOffsets: [CGFloat] = [0, -40, -60, -40, 0]
    private let icons: [String] = [
        "1.circle.fill",
        "2.circle.fill",
        "3.circle.fill",
        "4.circle.fill",
        "5.circle.fill"
    ]
    
    @State var score: Int = 0
    @State private var showGameView = false
    @StateObject var gameData = GameData()
    @State private var floating = false // Estado para animación

    var body: some View {
        ZStack {
            // Imagen de fondo
            Image("vistageneral")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                
            VStack(spacing: 20) {
                Text("Section 1: Rookie")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.8))

                // Botones animados
                ForEach(0..<xOffsets.count, id: \.self) { index in
                    if index == xOffsets.count / 2 {
                        HStack {
                            ellipseButton(image: icons[index])
                            
                            Image("natural")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        }
                    } else {
                        ellipseButton(image: icons[index])
                            .offset(x: xOffsets[index])
                    }
                }
                
                rectangleButton()
                
                Spacer()
            }
            ScoreView()
                .offset(x: UIScreen.main.bounds.width / 2 - 150, y: -UIScreen.main.bounds.height / 2 + 80)
        }
        .onAppear {
            floating.toggle() // Activa la animación cuando la vista aparece
        }
        .fullScreenCover(isPresented: $showGameView) {
            GameView(isPresented: $showGameView).environmentObject(gameData)
        }
        .environmentObject(gameData)
    }
    
    @ViewBuilder
    private func ellipseButton(image: String) -> some View {
        Button(action: {}, label: {
            Image(systemName: image)
                .resizable()
                .frame(width: 85, height: 85)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
        })
        .buttonStyle(DepthButtonStyle(fooregroundColor: Color(red: 0.2, green: 0.5, blue: 0.2), backgroundColor: Color(red: 0.6, green: 0.4, blue: 0.2))) // Verde oscuro con borde marrón claro
        .frame(width: 150, height: 140)
        .padding()
        .offset(y: floating ? -5 : 5) // Animación de flotación
        .animation(.easeInOut(duration: 1.5).repeatForever(), value: floating) // Hace que se repita siempre
    }
    
    @ViewBuilder
    private func rectangleButton() -> some View {
        Button {
            showGameView = true
        } label: {
            Text("Bonus")
                .fontWeight(.semibold)
                .foregroundStyle(Color.black)
        }
        .buttonStyle(DepthButtonStyle(fooregroundColor: .red, backgroundColor: .red, cornerRadius: 20))
        .frame(width: 250, height: 50)
    }
}

#Preview {
    ContentView(score: 0)
}
