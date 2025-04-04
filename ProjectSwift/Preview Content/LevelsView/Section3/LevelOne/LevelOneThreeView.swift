//
//  LevelOneThree.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 02/04/25.
//

import SwiftUI

struct LevelOneThreeView: View {
    var onFinish: (Int) -> Void
    @Binding var contentReturn: Bool
    @Binding var isPresented: Bool
    @EnvironmentObject var gameData: GameData
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    @State private var characterPosition = CGSize(width: 0, height: 0)
    @State private var backgroundOffset: CGFloat = 0
    @State private var collected = Set<Int>()
    @State private var currentCharacterImage = "derecha"
    @State private var moveTimer: Timer? = nil
    
    @State private var timeCounter = 0
    @State private var showStartPopup = true
    @State private var showEndPopup = false
    @State private var showFactPopup = false
    @State private var currentFact: String = ""
    @State private var save = false
    @State private var timer: Timer?
    @State private var estrellasObtenidas: Int = 0
    @State private var showExitConfirmation = false
    @State private var pauseTime = false
    @State private var showExitPopup = false
    @State private var showConfiguration = false
    @State private var rotateIcon = false
    
    @State private var scaleLeft = false
    @State private var scaleRight = false
    @State private var scaleUp = false
    @State private var scaleDown = false
    
    @State private var animateFish = false
    
    
    let itemImages = ["basmar1", "basmar2", "basmar3", "basmar4", "basmar5", "basmar6"]
    
    private func generateRandomPositions() -> [CGPoint] {
        var positions: [CGPoint] = []
        let screenWidth: CGFloat = 2000
        let screenHeight: CGFloat = 1000
        let padding: CGFloat = 100
        
        for _ in 0..<itemImages.count {
            let x = CGFloat.random(in: padding...(screenWidth - padding))
            let y = CGFloat.random(in: padding...(screenHeight - padding))
            positions.append(CGPoint(x: x, y: y))
        }
        return positions
    }
    
    @State private var itemPositions: [CGPoint] = []
    
    var body: some View {
        ZStack {
            ZStack {
                GeometryReader { geometry in
                    Image("fondomar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 1.85, height: geometry.size.height * 1.05  )
                        .offset(x: -backgroundOffset)
                        .animation(.easeInOut(duration: 0.3), value: backgroundOffset)
                        .ignoresSafeArea()
                }
                
                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        Text("Has recogido: \(collected.count)/\(itemImages.count)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(8)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                }
                .offset(y: 550)
                
                ForEach(0..<itemPositions.count, id: \.self) { index in
                    if !collected.contains(index) {
                        Image(itemImages[index])
                            .resizable()
                            .frame(width: 150, height: 150)
                            .position(x: itemPositions[index].x - backgroundOffset,
                                      y: itemPositions[index].y)
                            .animation(.easeInOut(duration: 0.3), value: backgroundOffset)
                    }
                }
                
                Image(currentCharacterImage)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .position(x: characterPosition.width + 55, y: characterPosition.height + 150)
                    .animation(.easeInOut(duration: 0.3), value: characterPosition)
                
                HStack(alignment: .center, spacing : 200) {
                    HStack(spacing: 20) {
                        Image(systemName: "arrow.left.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .scaleEffect(scaleLeft ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: scaleLeft)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        if moveTimer == nil {
                                            currentCharacterImage = "izquierda"
                                            scaleLeft = true
                                            moveTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                                                moveCharacter(x: -5, y: 0)
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        moveTimer?.invalidate()
                                        moveTimer = nil
                                        scaleLeft = false
                                    }
                            )
                            .foregroundColor(Color.aquaMa).opacity(0.4)
                        
                        VStack {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .scaleEffect(scaleUp ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: scaleUp)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { _ in
                                            if moveTimer == nil {
                                                currentCharacterImage = "arriba"
                                                scaleUp = true
                                                moveTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                                                    moveCharacter(x: 0, y: -5)
                                                }
                                            }
                                        }
                                        .onEnded { _ in
                                            moveTimer?.invalidate()
                                            moveTimer = nil
                                            scaleUp = false
                                        }
                                )
                                .foregroundColor(Color.aquaMa).opacity(0.4)
                            
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .scaleEffect(scaleDown ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: scaleDown)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { _ in
                                            if moveTimer == nil {
                                                currentCharacterImage = "abajo"
                                                scaleDown = true
                                                moveTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                                                    moveCharacter(x: 0, y: 5)
                                                }
                                            }
                                        }
                                        .onEnded { _ in
                                            moveTimer?.invalidate()
                                            moveTimer = nil
                                            scaleDown = false
                                        }
                                )
                                .foregroundColor(Color.aquaMa).opacity(0.4)
                            
                        }
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .scaleEffect(scaleRight ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: scaleRight)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        if moveTimer == nil {
                                            currentCharacterImage = "derecha"
                                            scaleRight = true
                                            moveTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                                                moveCharacter(x: 5, y: 0)
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        moveTimer?.invalidate()
                                        moveTimer = nil
                                        scaleRight = false
                                    }
                            )
                            .foregroundColor(Color.aquaMa).opacity(0.4)
                    }
                    Button(action: {
                        checkForPickup()
                    }) {
                        Text("Recoger")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: 140, height: 140)
                            .background(Color.aquaMa).opacity(0.4)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .offset(y: 450)
                
                HStack {
                    Button(action: {
                        pauseTime = true
                        timer?.invalidate()
                        showExitPopup = true
                    }) {
                        Image("boton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(15)
                    }
                    
                    Spacer()
                    
                    Text("Tiempo: \(timeCounter)")
                        .font(.custom("Bebas Neue", size: 25))
                        .foregroundColor(.black).opacity(0.5)
                    
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
                if showFactPopup {
                    Color.black.opacity(0.6).ignoresSafeArea()
                    VStack(spacing: 16) {
                        Text("Dato curioso")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                        Text(currentFact)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.black)
                        Button("OK") {
                            showFactPopup = false
                            showEndPopup = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .frame(maxWidth: 300)
                    .zIndex(3)
                }
                
                if showEndPopup {
                    endGamePopup()
                }
                
                if showStartPopup {
                    Color.black.opacity(0.7).ignoresSafeArea()
                    PopUpView(
                        popup: $showStartPopup,
                        save: $save,
                        instructions: "¡Ayuda a Chelonio a recojer toda la basura que se encuentra en el mar!"
                    )
                    .zIndex(1)
                    .allowsHitTesting(true)
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
                            .frame(width: 90, height: 20)
                            .padding().background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button("Continuar") {
                                pauseTime = false
                                startTimer()
                                showExitPopup = false
                            }
                            .frame(width: 90, height: 20)
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
            }
        }
        .onChange(of: save) {
            if save {
                itemPositions = generateRandomPositions()
                startTimer()
            }
        }
    }
    
    
    func moveCharacter(x: CGFloat, y: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        let characterWidth: CGFloat = 100
        let newX = characterPosition.width + x
        let newY = characterPosition.height + y
        
        if x > 0 {
            if characterPosition.width > 150 && backgroundOffset < 2000 - screenWidth {
                backgroundOffset = min(backgroundOffset + x, 2000 - screenWidth)
            } else {
                characterPosition.width = min(characterPosition.width + x, screenWidth - characterWidth)
            }
        }
        
        else if x < 0 {
            if backgroundOffset > 0 && characterPosition.width < 150 {
                backgroundOffset = max(backgroundOffset + x, 0)
            } else {
                characterPosition.width = max(characterPosition.width + x, 0)
            }
        }
        
        let screenHeight = UIScreen.main.bounds.height
        characterPosition.height = min(max(-150, newY), screenHeight - 150)
    }
    
    
    
    func checkForPickup() {
        for (index, pos) in itemPositions.enumerated() {
            let personajeX = characterPosition.width + 55
            let personajeY = characterPosition.height + 150
            
            let dx = pos.x - backgroundOffset - personajeX
            let dy = pos.y - personajeY
            
            if abs(dx) < 30 && abs(dy) < 30 {
                if !collected.contains(index) {
                    collected.insert(index)
                    playEffectSound(sound: .power)
                }
            }
        }
        if collected.count == itemImages.count {
            timer?.invalidate()
            calcularEstrellasYActualizarPuntuacion()
            showEndPopup = true
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if pauseTime || showStartPopup || showEndPopup || showExitPopup {
                return
            }
            timeCounter += 1
        }
    }
    
    private func calcularEstrellasYActualizarPuntuacion() {
        let estrellas: Int
        switch timeCounter {
        case 1...40: estrellas = 3
        case 41...80: estrellas = 2
        default: estrellas = 1
        }
        estrellasObtenidas = estrellas
        
        switch estrellas {
        case 1: gameData.score += 5
        case 2: gameData.score += 10
        case 3: gameData.score += 20
        default: break
        }
        
        if estrellas < 3, gameData.lives > 0 {
            gameData.lives -= 1
        }
    }
    
    private func endGamePopup() -> some View {
        VStack(spacing: 16) {
            Text("¡Nivel completado!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Image(systemName: index < estrellasObtenidas ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.yellow)
                }
            }
            
            Text("Tu tiempo fue de: \(timeCounter) segundos")
                .font(.subheadline)
                .foregroundColor(.black)
            
            HStack(spacing: 20) {
                Button("Reintentar") {
                    resetGame()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(width: 80, height: 40)
                
                Button("Salir") {
                    onFinish(estrellasObtenidas)
                    isPresented = false
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
    }
    
    private func resetGame() {
        timeCounter = 0
        estrellasObtenidas = 0
        collected.removeAll()
        currentCharacterImage = "derecha"
        characterPosition = CGSize(width: 0, height: 0)
        backgroundOffset = 0
        showEndPopup = false
        showFactPopup = false
        startTimer()
        itemPositions = generateRandomPositions()
    }
    @ViewBuilder
    func gameLayer() -> some View {
        
    }
    
    
    @ViewBuilder
    func fishesView() -> some View {
        ZStack {
            // Pez fijo en una esquina
            Image("pez2")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .scaleEffect(animateFish ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: animateFish)
                .onAppear { animateFish = true }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) // posición fija
            
            // Peces animados fijos
            AnimatedFish(
                imageLeft: "pez5",
                imageRight: "pez5volt",
                startX: -200,
                yPosition: 100,
                step: 600,
                delay: 0.2,
                size: 150
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // posición fija arriba
            
            AnimatedFish(
                imageLeft: "pez6",
                imageRight: "pez6volt",
                startX: -300,
                yPosition: 400,
                step: 400,
                delay: 0.7,
                size: 160
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            AnimatedFish(
                imageLeft: "pez1",
                imageRight: "pez1volt",
                startX: 400,
                yPosition: 200,
                step: 300,
                delay: 0.9,
                size: 150
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .allowsHitTesting(false) // para que no bloquee botones debajo
    }
}

#Preview {
    LevelOneThreeView(
        onFinish: { estrellas in
            print("Estrellas en preview \(estrellas)")
        },
        contentReturn: .constant(true),
        isPresented: .constant(true)
    )
        .environmentObject(GameData())
}

struct AnimatedFish: View {
    let imageLeft: String
    let imageRight: String
    let startX: CGFloat
    let yPosition: CGFloat
    let step: CGFloat
    let delay: Double
    let size: CGFloat

    @State private var currentX: CGFloat
    @State private var goingRight: Bool = true
    @State private var currentImage: String

    init(imageLeft: String, imageRight: String, startX: CGFloat, yPosition: CGFloat, step: CGFloat, delay: Double, size: CGFloat) {
        self.imageLeft = imageLeft
        self.imageRight = imageRight
        self.startX = startX
        self.yPosition = yPosition
        self.step = step
        self.delay = delay
        self.size = size

        // Estado inicial
        _currentX = State(initialValue: startX)
        _currentImage = State(initialValue: imageRight)
    }

    var body: some View {
        Image(currentImage)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .offset(x: currentX, y: yPosition)
            .onAppear {
                animate()
            }
    }

    func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.linear(duration: 2.0)) {
                currentX += step
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                // Cambiar dirección y la imagen
                goingRight.toggle()
                currentImage = goingRight ? imageRight : imageLeft
                stepAnimationLoop()
            }
        }
    }

    func stepAnimationLoop() {
        withAnimation(.linear(duration: 2.0)) {
            currentX += goingRight ? step : -step
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            goingRight.toggle()
            currentImage = goingRight ? imageRight : imageLeft
            stepAnimationLoop()
        }
    }
}
