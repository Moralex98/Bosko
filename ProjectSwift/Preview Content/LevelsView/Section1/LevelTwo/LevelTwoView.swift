//
//  LevelTwoView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 29/03/25.
//

import SwiftUI

struct LevelTwoView: View {
    @EnvironmentObject var gameData: GameData
    var onFinish: (Int) -> Void
    @Binding var contentReturn: Bool
    @Binding var isPresented: Bool

    var UISW: CGFloat { UIScreen.main.bounds.width }
    var UISH: CGFloat { UIScreen.main.bounds.height }

    @State private var piezasColocadas = 0
    @State private var piezasMezcladas: [String] = (1...9).map { "ab\($0)" }.shuffled()
    @State private var timeRemaining = 45
    @State private var showStartPopup = true
    @State private var showEndPopup = false
    @State private var estrellasObtenidas = 0
    @State private var timer: Timer?
    @State private var pauseTime = false
    @State private var save = false
    @State private var showExitPopup = false
    @State private var showConfiguration = false
    @State private var rotateIcon = false
    @State private var itemStates = Array(repeating: true, count: 9)

    private let sizeP: CGFloat = 330
    let gridSize: CGFloat = 400
    var cellSize: CGFloat {
        gridSize / 3
    }

    private let posicionesGrid: [CGSize] = [
        CGSize(width: -170, height: 100),
        CGSize(width: 0, height: 100),
        CGSize(width: 170, height: 100),
        CGSize(width: -170, height: 250),
        CGSize(width: 0, height: 250),
        CGSize(width: 170, height: 250),
        CGSize(width: -170, height: 400),
        CGSize(width: 0, height: 400),
        CGSize(width: 170, height: 400)
    ]

    var body: some View {
        ZStack {
            Image("fondovacio")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Image("abgenbasura")
                .resizable()
                .frame(width: 490, height: 490)
                .position(x: UIScreen.main.bounds.width * 0.48, y: 300)

            ForEach(0..<9, id: \.self) { index in
                let imageName = piezasMezcladas[index]
                let piezaNum = Int(imageName.dropFirst(2))!
                let row = (piezaNum - 1) / 3
                let col = (piezaNum - 1) % 3

                PuzzlePieceView(
                    imageName: imageName,
                    start: posicionesGrid[index],
                    targetPosition: targetPosition(row: row, col: col),
                    size: sizeP,
                    onDrop: { markItemDropped(at: index) }
                )
            }

            VStack {
                Spacer()
                Text("Piezas colocadas: \(piezasColocadas)/9")
                    .font(.headline)
                    .padding(.bottom, 40)
            }

            HStack {
                Button(action: {
                    pauseTime = true
                    timer?.invalidate()
                    showExitPopup = true
                }) {
                    Image(systemName: "arrowshape.turn.up.left")
                        .font(.title2.bold())
                        .frame(width: 30, height: 10)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }

                Spacer()

                Text("Tiempo: \(timeRemaining)")
                    .font(.custom("Bebas Neue", size: 25))
                    .foregroundColor(.blue)

                Spacer()

                Image(systemName: "gearshape.fill")
                    .font(.system(size: 35))
                    .rotationEffect(.degrees(rotateIcon ? 360 : 0))
                    .onTapGesture {
                        withAnimation {
                            showConfiguration.toggle()
                            rotateIcon.toggle()
                        }
                    }
            }
            .padding()
            .padding(.top, 05)
            .background(Color.gray.opacity(0.4))
            .position(x: UISW * 0.50, y: UISH * 0.02)

            if showConfiguration {
                ConfigurationView(showConfig: $showConfiguration)
                    .environmentObject(gameData)
                    .offset(x: 250, y: -535)
            }

            if showStartPopup {
                Color.black.opacity(0.7).ignoresSafeArea()
                PopUpView(
                    popup: $showStartPopup,
                    save: $save,
                    instructions: "!Ayuda a restaurar la limpieza de la ciudad colocando las piezas en su lugar¡"
                )
                .zIndex(1)
            }

            if showExitPopup {
                Color.black.opacity(0.6).ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("¿Deseas salir del juego?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("Si sales, no se contará ninguna estrella.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    HStack(spacing: 20) {
                        Button("Salir") {
                            isPresented = false
                            contentReturn = true
                        }
                        .padding().background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Continuar") {
                            pauseTime = false
                            startTimer()
                            showExitPopup = false
                        }
                        .padding().background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .frame(maxWidth: 300)
                .zIndex(2)
            }

            if showEndPopup {
                endGamePopup()
            }
        }
        .onChange(of: save) { if save { startTimer() } }
    }

    func targetPosition(row: Int, col: Int) -> CGPoint {
        let baseX = UIScreen.main.bounds.width * 0.5 - (cellSize * 1.5)
        let baseY: CGFloat = 300 - (cellSize * 1.5)
        let x = baseX + CGFloat(col) * cellSize + cellSize / 2
        let y = baseY + CGFloat(row) * cellSize + cellSize / 2
        return CGPoint(x: x, y: y)
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if pauseTime { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                t.invalidate()
                calcularEstrellasYActualizarPuntuacion()
                showEndPopup = true
            }
        }
    }

    private func markItemDropped(at index: Int) {
        if itemStates[index] {
            itemStates[index] = false
            piezasColocadas += 1
            playEffectSound(sound: .Basura)
            checkIfAllDropped()
        }
    }

    private func checkIfAllDropped() {
        if itemStates.allSatisfy({ !$0 }) {
            timer?.invalidate()
            calcularEstrellasYActualizarPuntuacion()
            showEndPopup = true
        }
    }

    private func resetGame() {
        timeRemaining = 45
        piezasColocadas = 0
        piezasMezcladas = (1...9).map { "ab\($0)" }.shuffled()
        itemStates = Array(repeating: true, count: 9)
        showEndPopup = false
        startTimer()
    }

    private func calcularEstrellasYActualizarPuntuacion() {
        let tiempo = 45 - timeRemaining
        let estrellas: Int
        switch tiempo {
        case 1...15: estrellas = 3
        case 16...30: estrellas = 2
        case 31...45: estrellas = 1
        default: estrellas = 0
        }
        estrellasObtenidas = estrellas

        switch estrellas {
        case 1: gameData.score += 5
        case 2: gameData.score += 10
        case 3: gameData.score += 15
        default: break
        }

        if estrellas == 1 || estrellas == 2, gameData.lives > 0 {
            gameData.lives -= 1
        }
    }

    private func endGamePopup() -> some View {
        VStack(spacing: 16) {
            Text("¡Nivel completado!")
                .font(.title).fontWeight(.bold)
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Image(systemName: index < estrellasObtenidas ? "star.fill" : "star")
                        .resizable().frame(width: 40, height: 40)
                        .foregroundColor(.yellow)
                }
            }
            Text("Tiempo: \(45 - timeRemaining) segundos")
                .font(.subheadline)
            HStack(spacing: 20) {
                Button("Reintentar") {
                    resetGame()
                }
                .padding().background(Color.blue)
                .foregroundColor(.white).cornerRadius(10)

                Button("Salir") {
                    onFinish(estrellasObtenidas)
                    isPresented = false
                    contentReturn = true
                }
                .padding().background(Color.green)
                .foregroundColor(.white).cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
    }
}

#Preview {
    LevelTwoView(
        onFinish: { estrellas in print("Estrellas: \(estrellas)") },
        contentReturn: .constant(true),
        isPresented: .constant(true)
    ).environmentObject(GameData())
}
