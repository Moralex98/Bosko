//
//  ContentLevek.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 08/03/25.
//

import SwiftUI

struct ContentLevelView: View {
    private let xOffsets: [CGFloat] = [0, -40, -60, -40, 0]
    private let icons: [String] = [
        "star.fill",
        "dumbbell.fill",
        "forward.fill",
        "star.fill",
        "bubbles.and.sparkles.fill"
        ]
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 20, content: {
                Text("Section 1: Rookie")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                
                ForEach(0..<xOffsets.count, id: \.self) { index in
                    if index == xOffsets.count / 2 {
                        HStack{
                            ellipseButton(image: icons[index])
                            
                            Image("natural")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        }
                    } else {
                        ellipseButton(image: icons[index])
                            .offset(x: xOffsets[index])
                    }
                }
                rectangleButton()
                
                Spacer()
            })
        }
    }
    @ViewBuilder
    private func ellipseButton(image: String) -> some View {
        Button(action: {}, label: {
            Image(systemName: image)
                .resizable()
                .frame(width: 30, height: 30)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
        })
        .buttonStyle(DepthButtonStyle(fooregroundColor: .green, backgroundColor: .blue))
        .frame(width: 80, height: 70)
        .padding()
    }
    @ViewBuilder
    private func rectangleButton() -> some View {
        
        Button {
            
        } label : {
            Text("Continue")
                .fontWeight(.semibold)
                .foregroundStyle(Color.black)
        }
        .buttonStyle(DepthButtonStyle(fooregroundColor: .red, backgroundColor: .red, cornerRadius: 20))
        .frame(width: 250, height: 50)
    }
}

#Preview {
    ContentLevelView()
}
