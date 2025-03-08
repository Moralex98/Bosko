//
//  DepthButtonStyle.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 08/03/25.
//

import SwiftUI
import Foundation

struct DepthButtonStyle: ButtonStyle {
    private enum Shape {
        case rectangle
        case elipse
    }
    
    private var fooregroundColor: Color
    private var backgroundColor: Color
    private var shape: Shape
    private var cornerRadius: CGFloat = 0
    private var yOffset: CGFloat {
        shape == .rectangle ? 4 : 8
    }
    
    // initiaiser for rectangle button
    init(fooregroundColor: Color, backgroundColor: Color, cornerRadius: CGFloat) {
        self.fooregroundColor = fooregroundColor
        self.backgroundColor = backgroundColor
        self.shape = .rectangle
        self.cornerRadius = cornerRadius
    }
    
    init(fooregroundColor: Color, backgroundColor: Color) {
        self.fooregroundColor = fooregroundColor
        self.backgroundColor = backgroundColor
        self.shape = .elipse
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            buttonShape(Color: backgroundColor)
            buttonShape(Color: fooregroundColor)
                .offset(y: configuration.isPressed ? 0 : -yOffset)
            configuration.label
                .foregroundStyle(backgroundColor)
                    .offset(y: -yOffset)
                    .offset(y: configuration.isPressed ? yOffset : 0)
        }
    }
    @ViewBuilder
    private func buttonShape(Color: Color) -> some View {
        switch shape {
        case .rectangle:
            RoundedRectangle(cornerRadius: cornerRadius).fill(Color)
        case .elipse:
            Ellipse().fill(Color)
        }
    }
}
