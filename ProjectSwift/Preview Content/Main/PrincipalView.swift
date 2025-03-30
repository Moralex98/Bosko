//
//  PrincipalView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 27/03/25.
//

import SwiftUI
import AVKit

struct PrincipalView: View {
    @State private var isPressedVoice: Bool = false
    @State private var showModesView = false
    @State private var showLoadingBar = false
    @State private var loadingProgress: CGFloat = 0.0
    
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var gameData: GameData

    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.colorOne, .colorTwo, .colorTree, .colorFour, .colorFive]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)

            VStack {
                Circle()
                    .frame(width: 300)
                    .padding(.bottom, 30)

                VStack(spacing: 30) {
                    Button {
                        showLoadingBar = true
                        startLoading()
                    } label: {
                        Text("START")
                            .font(.title2.bold())
                            .frame(width: 150, height: 30)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                    }

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 200, height: 15)
                            .foregroundColor(.white.opacity(0.3))

                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: loadingProgress * 200, height: 15)
                            .foregroundColor(.green)
                            .animation(.linear(duration: 0.05), value: loadingProgress)
                    }
                    .opacity(showLoadingBar ? 1 : 0)
                }
            }
        }
        .onAppear {
             playBackgroundSound(sound: .Introduc, fadeOutPrevious: false)
        }
        
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showModesView) {
            ModesView(showPrincipal: $showModesView)
                .environmentObject(gameData)
        }
        
    }

    private func startLoading() {
        loadingProgress = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if loadingProgress < 1.0 {
                loadingProgress += 0.02
            } else {
                timer.invalidate()
                showModesView = true
            }
        }
    }
}

#Preview {
    PrincipalView()
}
