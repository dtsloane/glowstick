//
//  ColourPicker.swift
//  control-component
//
//  Created by David Sloane on 20/01/2024.
//

import SwiftUI

struct ColorPicker: View {
    let colors: [Color] = [.orange, .red, .blue, .purple]
    @State private var isExpanded = false
    @Binding var selectedColor: Color

    var body: some View {
        HStack {
            if isExpanded {
                ForEach(colors, id: \.self) { color in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color)
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            selectedColor = color
                            withAnimation {
                                isExpanded.toggle()
                            }
                            triggerHapticFeedback()
                        }
                }
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(selectedColor)
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                            isExpanded.toggle()
                        }
                        triggerHapticFeedback()
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .transition(.slide)
        .animation(.spring(response: 0.5, dampingFraction: 0.9), value: isExpanded)
    }

    private func triggerHapticFeedback() {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
    }
}

