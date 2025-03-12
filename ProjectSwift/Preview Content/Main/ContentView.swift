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
    
    @State var score: Int = 0 // Se añade un valor inicial
    @State private var showGameView = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Section 1: Rookie")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                
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
            ScoreView(score: $score) // Se pasa correctamente como binding
                .offset(x: UIScreen.main.bounds.width / 2 - 100, y: -UIScreen.main.bounds.height / 2 + 50)
        }
        .fullScreenCover(isPresented: $showGameView) {
            GameView(isPresented: $showGameView, score: $score)
        }
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
        .buttonStyle(DepthButtonStyle(fooregroundColor: .green, backgroundColor: .blue)) // Corregido
        .frame(width: 150, height: 140)
        .padding()
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
        .buttonStyle(DepthButtonStyle(fooregroundColor: .red, backgroundColor: .red, cornerRadius: 20)) // Corregido
        .frame(width: 250, height: 50)
    }
}

#Preview {
    ContentView(score: 0)
}
