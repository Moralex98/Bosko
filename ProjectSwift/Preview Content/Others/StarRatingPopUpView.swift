//
//  StarsView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 22/03/25.
//
import SwiftUI

struct StarRatingPopup: View {
    var timeElapsed: Int
    var onRetry: () -> Void
    var onExit: () -> Void

    private func starCount() -> Int {
        switch timeElapsed {
        case 1...20: return 3
        case 21...40: return 2
        case 41...60: return 1
        default: return 0
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("¡Nivel completado!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)

            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    ZStack {
                        Image(systemName: "star")
                            .resizable()
                            .frame(width: 42, height: 42)
                            .foregroundColor(.black)
                        
                        Image(systemName: index < starCount() ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.yellow)
                    }
                }
            }

            Text("Tiempo: \(timeElapsed) segundos")
                .font(.subheadline)
                .foregroundColor(.black)

            HStack(spacing: 20) {
                Button("Reintentar") {
                    onRetry()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Salir") {
                    onExit()
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
}


#Preview("3 estrellas (rápido)") {
    StarRatingPopup(timeElapsed: 10, onRetry: {}, onExit: {})
}

#Preview("2 estrellas (medio)") {
    StarRatingPopup(timeElapsed: 35, onRetry: {}, onExit: {})
}

#Preview("1 estrella (tarde)") {
    StarRatingPopup(timeElapsed: 45, onRetry: {}, onExit: {})
}

#Preview("0 estrellas (fuera de rango)") {
    StarRatingPopup(timeElapsed: 65, onRetry: {}, onExit: {})
}



