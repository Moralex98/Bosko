//
//  PrincipalView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 27/03/25.
//

import SwiftUI

struct PrincipalView: View {

    @State var isPressedVoice: Bool = false
    @State private var showModesView = false
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.colorOne,.colorTwo,.colorTree,.colorFour,.colorFive,]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                VStack {
                    Circle()
                        .frame(width: 300)
                        .padding(.bottom, 30)
                    VStack(spacing: 50){
                        Button {
                            showModesView = true
                        } label: {
                            Text("START")
                                .font(.title2.bold())
                                .frame(width: 150, height: 30)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(15)
                        }
                        
                    }
                }
            }
            .ignoresSafeArea()
            .fullScreenCover(isPresented: $showModesView) {
                ModesView(showPrincipal: $showModesView)
            }
        }
}

#Preview {
    PrincipalView()
}
