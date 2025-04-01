//
//  BalloonView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 12/03/25.
//

import SwiftUI

struct BalloonView: View {
    var balloon: Balloon
    
    @State private var rotationAngle: Double = 0
    @State private var xOffset: CGFloat = 0
    
    var body: some View {
        Image(balloon.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: balloon.size, height: balloon.size) // Tamaño aleatorio
            .rotationEffect(.degrees(rotationAngle)) // Aplicar rotación
            .offset(x: xOffset) // Movimiento lateral
            .position(balloon.position)
            .opacity(balloon.isPopped ? 0.0 : 1.0) // Ocultar si está explotado
            .onAppear {
                startRotationAnimation()
                startSideMovement()
            }
    }
    
    // Animación de rotación continua
    private func startRotationAnimation() {
        withAnimation(Animation.linear(duration: Double.random(in: 2...4)).repeatForever(autoreverses: true)) {
            rotationAngle = balloon.rotation
        }
    }
    
    // Movimiento lateral aleatorio mientras sube
    private func startSideMovement() {
        withAnimation(Animation.easeInOut(duration: Double.random(in: 1.5...3)).repeatForever(autoreverses: true)) {
            xOffset = CGFloat.random(in: -30...30) // Movimiento lateral
        }
    }
}

#Preview {
    BalloonView(balloon: Balloon(
        position: CGPoint(x: 100, y: 100),
        imageName: "imagen1",
        speed: 5,
        isBad: false,
        rotation: 45,
        size: 80
    ))
}
