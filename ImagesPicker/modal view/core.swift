//
//  core.swift
//  ImagesPicker
//
//  Created by Michael on 17.01.2021.
//

import Foundation
import SwiftUI


enum ModalState: CGFloat {
    
    case closed ,partiallyRevealed, open
    
    func offsetFromTop() -> CGFloat {
        switch self {
        case .closed:
            return UIScreen.main.bounds.height + 200
        case .partiallyRevealed:
            return UIScreen.main.bounds.height * 1/4
        case .open:
            return 0
        }
    }
}

struct Modal {
    var position: ModalState  = .closed
    var dragOffset: CGSize = .zero
    var content: AnyView?
}


var GlobalModular: ModalManager = ModalManager()


struct ModalAnchorView: View {
    
    

    @ObservedObject var modalManager : ModalManager = GlobalModular
    
    var body: some View {
        ModalView(modal: $modalManager.modal)
    }
}


class ModalManager: ObservableObject {
    
    @Published var modal: Modal = Modal(position: .closed, content: nil)
    
    func newModal<Content: View>(position: ModalState, @ViewBuilder content: () -> Content ) {
        print("newModal")
        modal = Modal(position: position, content: AnyView(content()))
    }
    
    func openModal() {
        
        withAnimation {
            modal.position = .partiallyRevealed
        }
    }
    
    func closeModal() {
        modal.position = .closed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
            withAnimation {
//                self.modal =  Modal(position: .closed, content: nil)
            }
        }
    }
    
}

struct ModalView: View {
    
    // Modal State
    @Binding var modal: Modal
    @GestureState var dragState: DragStateModalarity = .inactive
    
    var animation: Animation {
        Animation
            .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)
            .delay(0)
    }
    
    var body: some View {
        
        let drag = DragGesture(minimumDistance: 5)
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation:  drag.translation)
                
        }
        .onChanged {
            self.modal.dragOffset = $0.translation
        }
            .onEnded(onDragEnded)
        
        return GeometryReader(){ geometry in
            ZStack(alignment: .top) {
                Color.black
                    .opacity(self.modal.position != .closed ? 0.35 : 0)
                    .onTapGesture {
                        withAnimation {
                            self.modal.position = .closed
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
                            withAnimation {
//                                self.modal =  Modal(position: .closed, content: nil)
                            }
                        }
                        
                        
                }
                ZStack(alignment: .top) {
                    
                    self.modal.content
                        .frame(height: UIScreen.main.bounds.height - (self.modal.position.offsetFromTop() + geometry.safeAreaInsets.top + self.dragState.translation.height))
                        
                }
                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .offset(y: max(0, self.modal.position.offsetFromTop() + self.dragState.translation.height + geometry.safeAreaInsets.top))
//                .gesture(drag)
                .animation(self.dragState.isDragging ? nil : self.animation)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        
        // Setting stops
        let higherStop: ModalState
        let lowerStop: ModalState
        
        // Nearest position for drawer to snap to.
        let nearestPosition: ModalState
        
        // Determining the direction of the drag gesture and its distance from the top
        let dragDirection = drag.predictedEndLocation.y - drag.location.y
        let offsetFromTopOfView = modal.position.offsetFromTop() + drag.translation.height
        
        // Determining whether drawer is above or below `.partiallyRevealed` threshold for snapping behavior.
        if offsetFromTopOfView <= ModalState.partiallyRevealed.offsetFromTop() {
            higherStop = .open
            lowerStop = .partiallyRevealed
        } else {
            higherStop = .partiallyRevealed
            
            lowerStop = .closed
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
//                withAnimation {
//                    self.modal =  Modal(position: .closed, content: nil)
//                }
//            }

            
          
           
        }
        
        // Determining whether drawer is closest to top or bottom
        if (offsetFromTopOfView - higherStop.offsetFromTop()) < (lowerStop.offsetFromTop() - offsetFromTopOfView) {
            nearestPosition = higherStop
        } else {
            nearestPosition = lowerStop
        }
        
        // Determining the drawer's position.
        if dragDirection > 0 {
            modal.position = lowerStop
        } else if dragDirection < 0 {
            modal.position = higherStop
        } else {
            modal.position = nearestPosition
        }
        
    }
    
}

enum DragStateModalarity {
    
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
