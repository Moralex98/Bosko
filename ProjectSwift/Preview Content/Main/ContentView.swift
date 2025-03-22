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
    @State private var floating = false
    @State private var levelStars: [Int] = Array(repeating: 0, count: 5)
    @State private var showLevelOne = false

    var body: some View {
        ZStack {
            Image("vistageneral")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                
            VStack() {
                Text("Section 1: Rookie")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.8))

                ForEach(0..<xOffsets.count, id: \.self) { index in
                    VStack() {
                        Button {
                            if index == 0 {
                                showLevelOne = true
                            }
                        } label: {
                            Image(systemName: icons[index])
                                .resizable()
                                .frame(width: 85, height: 85)
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(
                            DepthButtonStyle(
                                fooregroundColor: Color(red: 0.2, green: 0.5, blue: 0.2),
                                backgroundColor: Color(red: 0.6, green: 0.4, blue: 0.2)
                            )
                        )
                        .frame(width: 150, height: 140)
                        .padding()
                        .offset(y: floating ? -5 : 5)
                        .animation(.easeInOut(duration: 1.5).repeatForever(), value: floating)

                        HStack(spacing: 4) {
                            ForEach(0..<3) { starIndex in
                                Image(systemName: starIndex < levelStars[index] ? "star.fill" : "star")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(starIndex < levelStars[index] ? .red : .black)
                                    .offset(y: floating ? -5 : 5)
                                    .animation(.easeInOut(duration: 1.5).repeatForever(), value: floating)
                            }
                        }
                    }
                    .offset(x: xOffsets[index])
                }
                
                rectangleButton()
                
                Spacer()
            }
            ScoreView()
                .offset(x: UIScreen.main.bounds.width / 2 - 150, y: -UIScreen.main.bounds.height / 2 + 80)
        }
        .onAppear {
            floating.toggle()
        }
        .fullScreenCover(isPresented: $showLevelOne) {
            LevelOneView(
                onFinish: { estrellas in
                    levelStars[0] = estrellas
                },
                isPresented: $showLevelOne
            )
            .environmentObject(gameData)
        }

        .fullScreenCover(isPresented: $showGameView) {
            GameView(isPresented: $showGameView).environmentObject(gameData)
        }
        .environmentObject(gameData)
    }
    
    @ViewBuilder
    private func ellipseButton(image: String, index: Int) -> some View {
        Button(action: {
            if index == 0 {
                showLevelOne = true
            } else {
                
            }
        }, label: {
            Image(systemName: image)
                .resizable()
                .frame(width: 85, height: 85)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
        })
        .buttonStyle(
            DepthButtonStyle(
                fooregroundColor: Color(red: 0.2, green: 0.5, blue: 0.2),
                backgroundColor: Color(red: 0.6, green: 0.4, blue: 0.2))
        )
        .frame(width: 150, height: 140)
        .padding()
        .offset(y: floating ? -5 : 5)
        .animation(.easeInOut(duration: 1.5).repeatForever(), value: floating)
        
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
