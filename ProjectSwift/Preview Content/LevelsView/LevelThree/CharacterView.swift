//
//  CharacterView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 30/03/25.
//

import SwiftUI

struct CharacterView<Content: View>: View {
    var direction: String
    @Binding var position: CGSize
    var objectImageName: String? = nil
    var character: () -> Content
    var onMoveLeft: () -> Void
    var onMoveRight: () -> Void
    var onStopMoving: () -> Void
    var onJump: () -> Void
    var onPickup: () -> Void
    var showCharacter: Bool = true
    @Binding var animarD: Bool
    @Binding var animarI: Bool
    @Binding var facingRight: Bool
    @Binding var jumpOffset: CGFloat

    @State private var holdingTimer: Timer? = nil
    @State private var moveTimer: Timer?
    @State private var angulo: Bool = false
    @Binding var pickupItems: [PickupItem]


    var body: some View {
        ZStack {
            
            
            
            VStack(spacing: 20) {
                if showCharacter {
                    ZStack(alignment: .topTrailing) {
                        character()
                            .offset(x: position.width, y: position.height + jumpOffset)
                            
                        ForEach(pickupItems, id: \.id) { item in
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .offset(x: item.position.x, y: item.position.y)
                        }
                        
                        if let objectName = objectImageName {
                            Image(objectName)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .offset(x: 20, y: 80)
                        }
                    }
                    .id(objectImageName ?? "none")
                    .offset( y: -100)
                }

                HStack(spacing: 250) {
                    // Movimiento
                    HStack(spacing: 40) {
                        Button(action: {}) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .foregroundColor(.white)
                        }
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if !animarI {
                                        animarI = true
                                        facingRight = false
                                        startMovingLeft()
                                    }
                                }
                                .onEnded { _ in
                                    animarI = false
                                    stopMoving()
                                }
                        )

                        Button(action: {}) {
                            Image(systemName: "arrow.right")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .foregroundColor(.white)
                        }
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if !animarD {
                                        animarD = true
                                        facingRight = true
                                        startMovingRight()
                                    }
                                }
                                .onEnded { _ in
                                    animarD = false
                                    stopMoving()
                                }
                        )
                    }

                    // Acciones
                    HStack(spacing: 40) {
                        Button(action: onPickup) {
                            Text("Agarrar")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 100)
                                .background(Circle().fill(Color.red.opacity(0.8)))
                        }

                        Button(action: onJump) {
                            Text("Saltar")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 100)
                                .background(Circle().fill(Color.orange.opacity(0.8)))
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    func startMovingLeft() {
        stopMoving()
        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            position.width -= 2
        }
    }

    func startMovingRight() {
        stopMoving()
        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            position.width += 2
        }
    }

    func stopMoving() {
        moveTimer?.invalidate()
        moveTimer = nil
    }
}

struct DerechaView: View {
    @Binding var animarD: Bool
    @State private var anguloD = false
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Image("piernaID")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .offset(x: 4, y: 55)
                .rotationEffect(.degrees(anguloD ? 6 : -6), anchor: .top)

            Image("piernaDD")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .offset(x: 11, y: 58)
                .rotationEffect(.degrees(anguloD ? -6 : 6), anchor: .top)

            Image("jaguarsinD")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Image("BrazoDD")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .offset(x: -6, y: 34)
                .rotationEffect(.degrees(anguloD ? 4 : -5), anchor: .topLeading)
        }
        .onChange(of: animarD) { activo in
            timer?.invalidate()
            if activo {
                timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        anguloD.toggle()
                    }
                }
            } else {
                anguloD = false
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}


struct IzquierdaView: View {
    @Binding var animarI: Bool
    @State private var anguloI = false
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            // Pierna izquierda
            Image("piernaIID")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .offset(x: -5, y: 55)
                .rotationEffect(.degrees(anguloI ? -6 : 6), anchor: .top)

            // Pierna derecha
            Image("piernaDI")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .offset(x: -8, y: 58)
                .rotationEffect(.degrees(anguloI ? 6 : -6), anchor: .top)

            // Cuerpo
            Image("cuerpoI")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            // Brazo derecho
            Image("brazoDI")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .offset(x: 9, y: 30)
                .rotationEffect(.degrees(anguloI ? -5 : 5), anchor: .topLeading)
        }
        .onChange(of: animarI) { activo in
            timer?.invalidate()
            if activo {
                timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        anguloI.toggle()
                    }
                }
            } else {
                anguloI = false
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

#Preview {
    struct CharacterTestPreview: View {
        @State private var position = CGSize.zero
        @State private var facingRight = true
        @State private var animarD = false
        @State private var animarI = false
        @State private var jumpOffset: CGFloat = 0
        @State private var currentObject: String? = nil
        @State private var items: [PickupItem] = [
            PickupItem(imageName: "apple", position: CGPoint(x: -300, y: 60)),
            PickupItem(imageName: "apple", position: CGPoint(x: 100, y: 60)),
            PickupItem(imageName: "apple", position: CGPoint(x: 200, y: 60))
        ]

        var body: some View {
            CharacterView(
                direction: facingRight ? "right" : "left",
                position: $position,
                objectImageName: currentObject,
                character: {
                    Group {
                        if facingRight {
                            DerechaView(animarD: $animarD)
                        } else {
                            IzquierdaView(animarI: $animarI)
                        }
                    }
                },
                onMoveLeft: {
                    position.width -= 3
                    facingRight = false
                },
                onMoveRight: {
                    position.width += 3
                    facingRight = true
                },
                onStopMoving: {},
                onJump: {
                    withAnimation {
                        position.height -= 50
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            position.height = 0
                        }
                    }
                },
                onPickup: {
                    let characterX = position.width
                    let characterY = position.height + jumpOffset

                    var newItems = items
                    for i in newItems.indices {
                        let item = newItems[i]
                        let dx = abs(characterX - item.position.x)
                        let dy = abs(characterY - item.position.y)

                        if dx < 50 && dy < 50 && item.imageName == "apple" {
                            newItems[i].imageName = "banana"
                            break
                        }
                    }
                    items = newItems
                },
                showCharacter: true,
                animarD: $animarD,
                animarI: $animarI,
                facingRight: $facingRight,
                jumpOffset: $jumpOffset,
                pickupItems: $items
            )
        }
    }

    return CharacterTestPreview()
}
