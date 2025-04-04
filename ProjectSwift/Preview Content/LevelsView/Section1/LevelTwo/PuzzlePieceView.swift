//
//  PuzzlePieceView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 29/03/25.
//
import SwiftUI

struct PuzzlePieceView: View {
    var imageName: String
    var start: CGSize
    var targetPosition: CGPoint
    var size: CGFloat
    @Binding var position: CGPoint
    @Binding var isPlacedCorrectly: Bool
    var gameEnded: Bool
    var onDrop: () -> Void

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipped()
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isPlacedCorrectly && !gameEnded {
                            position = value.location
                        }
                    }
                    .onEnded { _ in
                        guard !gameEnded else { return }
                        if isNearTarget(position, target: targetPosition, size: size) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                position = targetPosition
                                isPlacedCorrectly = true
                                onDrop()
                            }
                        } else {
                            withAnimation(.easeInOut) {
                                position = initialPosition()
                            }
                        }
                    }
            )
    }

    private func initialPosition() -> CGPoint {
        CGPoint(
            x: UIScreen.main.bounds.width / 2 + start.width,
            y: UIScreen.main.bounds.height / 2 + start.height
        )
    }

    private func isNearTarget(_ current: CGPoint, target: CGPoint, size: CGFloat) -> Bool {
        let tolerance: CGFloat = size * 0.4
        let dx = abs(current.x - target.x)
        let dy = abs(current.y - target.y)
        return dx <= tolerance && dy <= tolerance
    }
}


#Preview {
    struct PreviewWrapper: View {
        @State private var position = CGPoint(x: UIScreen.main.bounds.width / 2 - 170, y: UIScreen.main.bounds.height / 2 + 100)
        @State private var placed = false

        var body: some View {
            PuzzlePieceView(
                imageName: "ab1",
                start: CGSize(width: -170, height: 100),
                targetPosition: CGPoint(x: 100, y: 100),
                size: 133.33,
                position: $position,
                isPlacedCorrectly: $placed,
                gameEnded: false,
                onDrop: {}
            )
        }
    }

    return PreviewWrapper()
}



