//
//  PopUp.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 15/03/25.
//

import SwiftUI

struct PopUpView: View {
    @Binding var popup: Bool
    @Binding var save: Bool
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack{
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.white)
                
                VStack{
                    Image(systemName: "checkmark.seal.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    
                    Text("¿Listo Para comenzar?")
                        .font(.largeTitle.bold())
                        .padding(.top, 50)
                    
                    Button{
                        withAnimation(.easeInOut(duration: 0.3)) {
                            popup = false
                            save = true
                        }
                    }label: {
                        Text("Empezar")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                            .padding()
                    }
                    .background(.blue)
                    .cornerRadius(15)
                    .padding(.top, 30)
                }
            }
            .frame(width: UISW * 0.8, height: UISH * 0.4)
        }.ignoresSafeArea()
    }
}
struct PopUpView_Previews: PreviewProvider {
    @State static var popup = true
    @State static var save = true
    
    static var previews: some View{
        PopUpView(popup: $popup, save: $save)
            
    }
}

