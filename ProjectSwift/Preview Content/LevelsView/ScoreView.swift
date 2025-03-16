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
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.05))
                        .frame(width: 250, height: 60)
                    
                    HStack(spacing: 40) {
                        Text("Puntuación: \(Text("\(gameData.score)").foregroundColor(.orange))")
                            .font(.custom("Bebas Neue", size: 25))
                            .foregroundColor(.red)
                        
                        Image(systemName: "gearshape.2.fill")
                            .foregroundColor(.black)
                            .font(.title)
                            .scaleEffect(isPulsing ? 1.2 : 1.0) // ✅ Pulsación
                            .animation(.easeInOut(duration: 0.2), value: isPulsing)
                            .onTapGesture {
                                withAnimation {
                                    showConfiguration.toggle() // ✅ Alterna la visibilidad de `ConfigurationView`
                                    isPulsing.toggle() // ✅ Activa la animación de pulsación
                                    
                                    // Vuelve al tamaño normal después de 0.2s
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        isPulsing = false
                                    }
                                }
                            }
                    }
                    .padding()
                }
                ConfigurationView()
                    .opacity(showConfiguration ? 1 : 0)
            }
        }
    }
}

#Preview {
    ScoreView().environmentObject(GameData())
}


class GameData: ObservableObject {
    @Published var score: Int = 0
}

struct ConfigurationView: View {
    @State var isPressedVoice: Bool = false
    @State var isPressedSound: Bool = false
    @State private var isPulsing1 = false
    @State private var isPulsing2 = false
    
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.05))
                .frame(width: 150, height: 60)
            
            HStack(spacing: 25) {
                Image(systemName: isPressedVoice ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .foregroundColor(.black)
                    .font(.title)
                    .scaleEffect(isPulsing1 ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isPulsing1)
                    .onTapGesture {
                        isPressedVoice.toggle()
                        if isPressedVoice {
                            stopSound() // ✅ Detiene el sonido
                        } else {
                            playSound(sound: .chilldrum) // ✅ Reproduce el sonido
                                }
                        isPulsing1.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isPulsing1 = false
                            }
                        }
                Image(systemName: isPressedSound ? "waveform.slash" :  "waveform")
                    .foregroundColor(.black)
                    .font(.title)
                    .scaleEffect(isPulsing2 ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isPulsing2)
                    .onTapGesture {
                        isPressedSound.toggle() // ✅ Cambia el icono de sonido
                            if isPressedSound {
                                playSound(sound: .chilldrum) // ✅ Activa el sonido
                            } else {
                                stopSound() // ✅ Desactiva el sonido
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
