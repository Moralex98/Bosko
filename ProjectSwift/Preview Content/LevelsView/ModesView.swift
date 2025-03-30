//
//  ModesView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 26/03/25.
//

import SwiftUI

struct ModesView: View {
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    @Binding var showPrincipal: Bool

    enum SelectedView {
        case main
        case levelP
        case levelG
        case menu
    }

    @State private var selectedView: SelectedView = .main
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                switch selectedView {
                case .main:
                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack {
                            Image("fondo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 3, height: geometry.size.height * 1.03)

                            HStack(spacing: 450) {
                                ForEach(cards) { card in
                                    VStack {
                                        Button(action: {
                                            selectedView = card.destination
                                        }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(LinearGradient(
                                                        gradient: Gradient(colors: card.colors),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing))
                                                    .frame(width: 350, height: 250)

                                                Image(card.imageName)
                                                    .resizable()
                                                    .frame(width: 330, height: 230)
                                                    .cornerRadius(10)
                                                    .padding()
                                            }
                                        }
                                        Text(card.title)
                                            .font(.largeTitle.bold())
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            .padding()
                        }
                    }

                default:
                    EmptyView()
                }
            }
            .fullScreenCover(isPresented: Binding<Bool>(
                get: { selectedView != .main },
                set: { if !$0 { selectedView = .main } }
            )) {
                switch selectedView {
                case .levelP:
                    ContentView(
                        score: 0,
                        isPressented: Binding(
                            get: { selectedView != .main },
                            set: { if !$0 { selectedView = .main } }
                        )
                    )

                case .levelG:
                    ContentView(
                        score: 0,
                        isPressented: Binding(
                            get: { selectedView != .main },
                            set: { if !$0 { selectedView = .main } }
                        )
                    )

                case .menu:
                    ContentView(
                        score: 0,
                        isPressented: Binding(
                            get: { selectedView != .main },
                            set: { if !$0 { selectedView = .main } }
                        )
                    )

                default:
                    EmptyView()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    var cards: [Card] {
        [
            Card(title: "PUZZLE", imageName: "puzzle", colors: [.colorOne, .colorTwo], destination: .levelP),
            Card(title: "GEOMETRY", imageName: "geometry", colors: [.colorOne, .colorFive], destination: .levelG),
            Card(title: "NUMBERS", imageName: "numbers", colors: [.colorTree, .colorTwo], destination: .levelP)
        ]
    }

    struct Card: Identifiable {
        let id = UUID()
        let title: String
        let imageName: String
        let colors: [Color]
        let destination: SelectedView
    }
}

#Preview {
    StatefulPreviewWrapper(false) { show in
        ModesView(showPrincipal: show)
    }
}

