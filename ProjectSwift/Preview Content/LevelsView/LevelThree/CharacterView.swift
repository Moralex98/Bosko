//
//  CharacterView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 30/03/25.
//

import SwiftUI

struct CharacterView: View {
    var direction: String
    var position: CGSize
    var onMoveLeft: () -> Void
    var onMoveRight: () -> Void
    var onStopMoving: () -> Void
    var onJump: () -> Void
    var onPickup: () -> Void
    var showCharacter: Bool = true
    var objectImageName: String? = nil

    var body: some View {
        ZStack{
            Color.tierraCafe
                .ignoresSafeArea(.container, edges: .all)
            
            VStack(spacing: 20) {
                if showCharacter {
                    ZStack(alignment: .topTrailing) {
                        Image(direction == "right" ? "derecha" : "izquierda")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .offset(position)
                            .animation(.easeInOut(duration: 0.2), value: position)

                        if let objectName = objectImageName {
                            Image(objectName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .offset(x: 20, y: -10)
                        }
                    }
                }

                HStack(spacing: 250) {
                    // Movimiento
                    HStack(spacing: 40) {
                        Button(action: {}, label: {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .foregroundColor(.white)
                        })
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in onMoveLeft() }
                                .onEnded { _ in onStopMoving() }
                        )

                        Button(action: {}, label: {
                            Image(systemName: "arrow.right")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .foregroundColor(.white)
                        })
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in onMoveRight() }
                                .onEnded { _ in onStopMoving() }
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
}

#Preview {
    CharacterView(
        direction: "right",
        position: .zero,
        onMoveLeft: {},
        onMoveRight: {},
        onStopMoving: {},
        onJump: {},
        onPickup: {},
        showCharacter: true,
        objectImageName: "apple"
    )
}
