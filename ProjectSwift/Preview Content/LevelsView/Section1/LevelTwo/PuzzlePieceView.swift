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
    var onDrop: () -> Void

    @State private var position: CGPoint
    @State private var isPlacedCorrectly = false

    init(imageName: String, start: CGSize, targetPosition: CGPoint, size: CGFloat, onDrop: @escaping () -> Void) {
        self.imageName = imageName
        self.start = start
        self.targetPosition = targetPosition
        self.size = size
        self.onDrop = onDrop
        _position = State(initialValue: CGPoint(
            x: UIScreen.main.bounds.width / 2 + start.width,
            y: UIScreen.main.bounds.height / 2 + start.height
        ))
    }

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
                        if !isPlacedCorrectly {
                            position = value.location
                        }
                    }
                    .onEnded { _ in
                        if isInsideTarget(position, target: targetPosition, size: size) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                position = targetPosition
                                if !isPlacedCorrectly {
                                    isPlacedCorrectly = true
                                    onDrop()
                                }
                            }
                        } else {
                            // Regresa a su lugar si no está bien colocada
                            withAnimation(.easeInOut) {
                                position = CGPoint(
                                    x: UIScreen.main.bounds.width / 2 + start.width,
                                    y: UIScreen.main.bounds.height / 2 + start.height
                                )
                            }
                        }
                    }
            )
    }

    private func isInsideTarget(_ current: CGPoint, target: CGPoint, size: CGFloat) -> Bool {
        let half = size / 2
        let frame = CGRect(x: target.x - half, y: target.y - half, width: size, height: size)
        return frame.contains(current)
    }
}

#Preview {
    PuzzlePieceView(
        imageName: "ab1",
        start: CGSize(width: -170, height: 100),
        targetPosition: CGPoint(x: 100, y: 100),
        size: 133.33,
        onDrop: {}
    )
}


