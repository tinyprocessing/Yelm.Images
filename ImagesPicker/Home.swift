//
//  ContentView.swift
//  ImagesPicker
//
//  Created by Michael on 17.01.2021.
//

import SwiftUI

struct Home: View {
    
    @ObservedObject var modal : ModalManager = GlobalModular

    
    var body: some View {
        VStack{
            
            Text("Press button to select some photos")
            
            Button(action: {
                
                DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                    self.modal.openModal()
                }
                
            }) {
                
                Image(systemName: "plus")
                    .foregroundColor(Color.theme)
                    .padding(10)
                    .font(.system(size: 20, weight: .bold, design: .rounded))

                
            }
            .buttonStyle(ScaleButtonStyle())
            
        }.onAppear{
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.modal.newModal(position: .closed) {
                    ModalImages()
                        .clipped()
                }
            }
            
        }
    }
}

