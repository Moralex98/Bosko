//
//  ScoreView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 12/03/25.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var gameData: GameData
    @State private var showConfiguration = false
    @State private var showHeartShop = false
    @State private var isPulsingC = false
    @State private var isPulsingH = false
    @State private var rotateIcon = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cyan.opacity(0.4))
                .frame(width: 280, height: 50)
            
            HStack(spacing: 20) {
                Text("Puntuación:  \(Text("\(gameData.score)").foregroundColor(.orange))")
                    .font(.custom("Bebas Neue", size: 25))
                    .foregroundColor(.red)
                
                HStack(spacing: 10) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(gameData.lives > 0 ? .red : .gray)
                        .font(.system(size: 30))
                        .scaleEffect(isPulsingH ? 1.2 : 1.0)
                        .animation(.easeIn(duration: 1), value: rotateIcon)
                        .onTapGesture {
                            withAnimation {
                                showConfiguration = false
                                showHeartShop.toggle()
                                isPulsingH = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isPulsingH = false
                                }
                            }
                        }
                    
                    Text("\(gameData.lives)")
                        .font(.custom("Bebas Neue", size: 25))
                }
                
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .scaleEffect(isPulsingC ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isPulsingC)
                    .rotationEffect(.degrees(rotateIcon ? 360 : 0))
                    .onTapGesture {
                        withAnimation {
                            showHeartShop = false
                            showConfiguration.toggle()
                            isPulsingC = true
                            rotateIcon.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isPulsingC = false
                            }
                        }
                    }
            }
            .padding()
            
            if showConfiguration {
                ConfigurationView(showConfig: $showConfiguration)
                    .environmentObject(gameData)
                    .offset(y: 70)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: showConfiguration)
            }
            
            if showHeartShop {
                HeartShopView(isPresented: $showHeartShop)
                    .environmentObject(gameData)
                    .offset(y: 160)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: showHeartShop)
            }
        }
    }

    private func heartOption(amount: Int, cost: Int) -> some View {
        VStack {
            ZStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 45))

                Text("\(amount)")
                    .font(.custom("Bebas Neue", size: 25))
                    .foregroundColor(.white)
            }
            Text("\(cost) pts")
                .font(.custom("Bebas Neue", size: 25))
                .foregroundColor(.black)
        }
        .frame(width: 70)
    }
}

#Preview {
    ScoreView().environmentObject(GameData())
}

class GameData: ObservableObject {
    @Published var score: Int = 0
    @Published var lives: Int = 5
}

struct ConfigurationView: View {
    @EnvironmentObject var gameData: GameData
    @Binding var showConfig: Bool

    @State private var isPulsing1 = false
    @State private var isPulsing2 = false
    @State private var isPressedVoice: Bool = false
    @State private var isPressedSound: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cyan.opacity(0.4))
                .frame(width: 150, height: 50)

            VStack(spacing: 25) {
                HStack(spacing: 25) {
                    Image(systemName: isPressedVoice ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .foregroundColor(.black)
                        .font(.title)
                        .scaleEffect(isPulsing1 ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isPulsing1)
                        .onTapGesture {
                            isPressedVoice.toggle()
                            if isPressedVoice {
                                stopSound()
                            } else {
                                playSound(sound: .chilldrum)
                            }
                            isPulsing1.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isPulsing1 = false
                            }
                        }

                    Image(systemName: isPressedSound ? "waveform.slash" : "waveform")
                        .foregroundColor(.black)
                        .font(.title)
                        .scaleEffect(isPulsing2 ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isPulsing2)
                        .onTapGesture {
                            isPressedSound.toggle()
                            if isPressedSound {
                                playSound(sound: .chilldrum)
                            } else {
                                stopSound()
                            }
                            isPulsing2.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isPulsing2 = false
                            }
                        }
                }
            }
        }
    }
}
