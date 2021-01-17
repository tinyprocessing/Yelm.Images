//
//  buttons.swift
//  ImagesPicker
//
//  Created by Michael on 17.01.2021.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import PassKit

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct ApplePayButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return ApplePayButton()
    }
}


struct ApplePayButton: UIViewRepresentable {
    func updateUIView(_ uiView: PKPaymentButton, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> PKPaymentButton {
        return PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)
    }
}
