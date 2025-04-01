//
//  ShootView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 12/03/25.
//

//
//  ShootView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 12/03/25.
//

import SwiftUI

struct LevelThreeView: View {
    var onFinish: (Int) -> Void
    @Binding var contentReturn: Bool
    @Binding var isPresented: Bool
    @EnvironmentObject var gameData: GameData
    @State private var balloons: [Balloon] = []
    @State private var timeRemaining = 30
    @State private var gameActive = true
    @State private var speedMultiplier = 1.0
    @State private var showAlert = false
    @State private var showPopup = true
    @State private var save = false
    @State private var balloonQueue: [String] = []
    @State private var showConfiguration = false
    @State private var rotateIcon = false
    @State private var showStartPopup = true
    @State private var estrellasObtenidas = 0
    @State private var goodBalloonsPopped = 0

    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let balloonSpawnInterval = 1.0
    private let maxBalloons = 50

    private let goodBalloons = ["imagen1", "imagen2", "imagen3", "imagen4", "imagen5", "imagen6"]
    private let badBalloons = ["animal1", "animal2", "animal3", "animal4"]

    var UISW: CGFloat { UIScreen.main.bounds.width }
    var UISH: CGFloat { UIScreen.main.bounds.height }

    var body: some View {
        ZStack {
            Image("game1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ForEach(balloons) { balloon in
                BalloonView(balloon: balloon)
                    .onTapGesture {
                        popBalloon(balloon)
                    }
            }

            HStack {
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
            .padding(.top, 5)
            .background(Color.gray.opacity(0.4))
            .position(x: UISW * 0.50, y: UISH * 0.02)

            if showConfiguration {
                ConfigurationView(showConfig: $showConfiguration)
                    .environmentObject(gameData)
                    .offset(x: 250, y: -545)
            }

            if showStartPopup {
                Color.black.opacity(0.7).ignoresSafeArea()
                startPopup()
                    .zIndex(1)
                    .allowsHitTesting(true)
            }

            if !gameActive {
                endGamePopup()
            }
        }
        .onChange(of: save) {
            if save {
                startGameTimer()
                startSpawningBalloons()
            }
        }
    }

    func startGameTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                gameActive = false
                calcularEstrellasYActualizarPuntuacion()
            }
        }
    }

    func startSpawningBalloons() {
        var balloonsSpawned = 0
        Timer.scheduledTimer(withTimeInterval: balloonSpawnInterval, repeats: true) { timer in
            if balloonsSpawned < maxBalloons && gameActive {
                spawnBalloon()
                balloonsSpawned += 1
            } else {
                timer.invalidate()
            }
        }
    }

    private func getNextImage(isBad: Bool) -> String {
        if balloonQueue.isEmpty {
            let source = isBad ? badBalloons : goodBalloons
            balloonQueue = source.shuffled()
        }
        return balloonQueue.removeFirst()
    }

    private func spawnBalloon() {
        let randomXPosition = CGFloat.random(in: 50...(screenWidth - 50))
        let isBad = Bool.random()
        let imageName = getNextImage(isBad: isBad)
        let randomSpeed = Double.random(in: 1...3) / speedMultiplier
        let randomRotation = Double.random(in: -360...360)
        let randomSize = CGFloat.random(in: 100...300)

        let initialPosition = CGPoint(x: randomXPosition, y: screenHeight + 50)

        let balloon = Balloon(
            position: initialPosition,
            imageName: imageName,
            speed: randomSpeed,
            isBad: isBad,
            rotation: randomRotation,
            size: randomSize
        )

        balloons.append(balloon)

        withAnimation(.linear(duration: randomSpeed)) {
            if let index = balloons.firstIndex(where: { $0.id == balloon.id }) {
                balloons[index].position = CGPoint(x: balloons[index].position.x, y: -150)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + randomSpeed) {
            balloons.removeAll { $0.id == balloon.id }
        }
    }

    private func popBalloon(_ balloon: Balloon) {
        if let index = balloons.firstIndex(where: { $0.id == balloon.id }) {
            if !balloons[index].isPopped {
                balloons[index].isPopped = true
                playEffectSound(sound: .Basura)

                if balloons[index].isBad {
                    gameData.score = max(0, gameData.score - 5)
                } else {
                    gameData.score += 5
                    goodBalloonsPopped += 1
                }
                speedMultiplier += 0.1
            }
        }
    }

    private func calcularEstrellasYActualizarPuntuacion() {
        switch goodBalloonsPopped {
        case 1...5: estrellasObtenidas = 1
        case 6...10: estrellasObtenidas = 2
        case 11...: estrellasObtenidas = 3
        default: estrellasObtenidas = 0
        }

        switch estrellasObtenidas {
        case 1: gameData.score += 5
        case 2: gameData.score += 10
        case 3: gameData.score += 20
        default: break
        }

        if estrellasObtenidas <= 2 && gameData.lives > 0 {
            gameData.lives -= 1
        }
    }

    private func resetGame() {
        timeRemaining = 30
        gameActive = true
        balloons.removeAll()
        speedMultiplier = 1.0
        goodBalloonsPopped = 0
        startGameTimer()
        startSpawningBalloons()
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

            Text("Tu puntuación es de : \(goodBalloonsPopped)")
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

    private func startPopup() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(.white)

            VStack(spacing: 20) {
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130)
                    .foregroundColor(.blue)

                Text("¿Listo para comenzar?")
                    .font(.largeTitle.bold())
                    .padding(.top, 10)

                Text("Recoge toda la basura que puedas y evita los incorrectos. ¡Suerte!")
                    .multilineTextAlignment(.center)
                    .font(.custom("Futura-Medium", size: 24))
                    .padding(.horizontal)
                    .foregroundColor(.red)

                HStack(spacing: 20) {
                    Button("Regresar") {
                        isPresented = false
                    }
                    .padding().background(Color.red).foregroundColor(.white).cornerRadius(15)

                    Button("Empezar") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showStartPopup = false
                            save = true
                        }
                    }
                    .padding().background(Color.blue).foregroundColor(.white).cornerRadius(15)
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.45)
        .ignoresSafeArea()
    }
}


#Preview {
    LevelThreeView(
        onFinish: { _ in }, contentReturn: .constant(true),
        isPresented: .constant(true)
    ).environmentObject(GameData())
}
