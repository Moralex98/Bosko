//
//  LevelOne.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 30/03/25.
//
import SwiftUI

struct LevelThreeView: View {
    @State private var characterOffset: CGSize = CGSize(width: -365, height: -250)
    @State private var facingRight: Bool = true
    @State private var isJumping = false
    @State private var jumpHeight: CGFloat = 100
    @State private var groundY: CGFloat = 0
    @State private var obstacles: [CGRect] = []
    @State private var pickupItems: [PickupItem] = [
        PickupItem(imageName: "apple", position: CGPoint(x: 100, y: -30)),
        PickupItem(imageName: "apple", position: CGPoint(x: 300, y: -30)),
        PickupItem(imageName: "apple", position: CGPoint(x: 600, y: -30))
    ]
    @State private var objectImages: [(image: String, position: CGPoint)] = []
    @State private var collectedCount = 0
    @State private var holdingTimer: Timer? = nil
    @State private var timeRemaining = 60
    @State private var showStartPopup = true
    @State private var showEndPopup = false
    @State private var itemsRemaining = 14
    @State private var save = false
    @State private var timer: Timer?
    @State private var itemStates: [Bool] = Array(repeating: true, count: 14)
    @State private var estrellasObtenidas: Int = 0
    @State private var showExitConfirmation = false
    @State private var pauseTime = false
    @State private var showExitPopup = false
    @State private var showConfiguration = false
    @State private var rotateIcon = false
    @State private var animarD = false
    @State private var animarI = false
    @State private var jumpOffset: CGFloat = 0
    @State private var heldObject: String? = nil
    let pickupImage = "apple"
    let collectedImage = "banana"


    @Binding var contentReturn: Bool
    @Binding var isPresented: Bool

    let moveSpeed: CGFloat = 5
    let worldWidth: CGFloat = 2000
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.blue.opacity(0.1).ignoresSafeArea()

            VStack(spacing: 0) {
                GeometryReader { geo in
                    ZStack(alignment: .bottomLeading) {
                        Color.green.edgesIgnoringSafeArea(.all).opacity(0.5)

                        Rectangle()
                            .fill(Color.green)
                            .frame(width: worldWidth, height: 50)

                        ForEach(0..<5, id: \.self) { i in
                            let rect = CGRect(x: CGFloat(i) * 300 + 200, y: geo.size.height - 150, width: 80, height: 100)
                            Rectangle()
                                .fill(Color.brown)
                                .frame(width: rect.width, height: rect.height)
                                .position(x: rect.midX, y: rect.midY)
                                .onAppear {
                                    if !obstacles.contains(rect) {
                                        obstacles.append(rect)
                                    }
                                }
                        }

                        ForEach(pickupItems) { item in
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .offset(x: item.position.x, y: item.position.y)
                        }

                       ForEach(objectImages, id: \.self.position) { obj in
                            Image(obj.image)
                                .resizable()
                                .frame(width: 40, height: 40)
                               .offset(x: obj.position.x, y: obj.position.y - 30)
                        }
                    }
                    .frame(width: worldWidth, height: geo.size.height)
                    .offset(x: -(characterOffset.width - screenWidth / 2).clamped(to: 0...(worldWidth - screenWidth)))
                    .onAppear {
                        groundY = geo.size.height - 50
                    }
                }
                .frame(height: screenHeight * 2 / 3)

                CharacterView(
                    direction: facingRight ? "right" : "left",
                    position: $characterOffset,
                    objectImageName: heldObject,
                    character: {
                        Group {
                            if facingRight {
                                DerechaView(animarD: $animarD)
                            } else {
                                IzquierdaView(animarI: $animarI)
                            }
                        }
                    },
                    onMoveLeft: { startHolding(direction: true) },
                    onMoveRight: { startHolding(direction: false) },
                    onStopMoving: { stopHolding() },
                    onJump: { jump() },
                    onPickup: { tryPickup() },
                    showCharacter: true,
                    animarD: $animarD,
                    animarI: $animarI,
                    facingRight: $facingRight,
                    jumpOffset: $jumpOffset,
                    pickupItems: $pickupItems
                )
                .frame(height: screenHeight / 3)
                .id(heldObject ?? "none")
            }

            Text("Objetos atrapados: \(collectedCount)/3")
                .font(.custom("Bebas Neue", size: 30))
                .foregroundColor(.black)
                .offset(x: 300, y:-40)

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
            .position(x: screenWidth * 0.50, y: screenHeight * 0.04)

            if showConfiguration {
                ConfigurationView(showConfig: $showConfiguration)
                    .offset(x: 590, y: -1110)
            }
        }
        .onDisappear {
            stopHolding()
        }
    }

    func moveCharacter(left: Bool) {
        facingRight = !left
        let delta: CGFloat = left ? -moveSpeed : moveSpeed
        let nextX = characterOffset.width + delta

        guard nextX >= 0 && nextX <= worldWidth - 80 else { return }

        let futureFrame = CGRect(x: nextX, y: groundY - 80 + characterOffset.height, width: 80, height: 80)
        for obs in obstacles {
            if obs.intersects(futureFrame) { return }
        }

        characterOffset.width += delta
    }

    func jump() {
        guard !isJumping else { return }
        isJumping = true

        withAnimation(.easeOut(duration: 0.3)) {
            jumpOffset = -jumpHeight
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeIn(duration: 0.3)) {
                jumpOffset = 0
                isJumping = false
            }
        }
    }

    func tryPickup() {
        let characterX = characterOffset.width + screenWidth / 2
        let characterY = groundY + characterOffset.height + jumpOffset

        pickupItems.removeAll { item in
            let itemY = groundY + item.position.y
            let dx = abs(characterX - item.position.x)
            let dy = abs(characterY - itemY)

            let isNear = dx < 50 && dy < 50

            if isNear {
                collectedCount += 1
                objectImages.append((collectedImage, item.position))
                heldObject = collectedImage
            }

            return isNear
        }
    }

    func startHolding(direction left: Bool) {
        stopHolding()
        holdingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            moveCharacter(left: left)
        }
    }

    func stopHolding() {
        holdingTimer?.invalidate()
        holdingTimer = nil
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#Preview {
    LevelThreeView(contentReturn: .constant(true), isPresented: .constant(true))
        .environmentObject(GameData())
}
