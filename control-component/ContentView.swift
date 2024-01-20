//
//  ContentView.swift
//  control-component
//
//  Created by David Sloane on 19/01/2024.
//

import SwiftUI

struct Slider: View {
    // Constants
    enum Const {
        static let shapeSize: CGSize = .init(width: 120.0, height: 360.0)
        static let cornerRadius: CGFloat = 38.0
    }
    
    // Variables
    @State var value = 0.0
    @State var hScale = 1.0
    @State var vScale = 1.0
    @State var vOffset: CGFloat = 0.0
    @State var startValue: CGFloat = 0.0
    @State var anchor: UnitPoint = .center
    @State var isTouching = false
    @State private var selectedColor: Color = .orange // Default color

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    VStack {
                        slider
                            .clipShape(RoundedRectangle(cornerRadius: Const.cornerRadius, style: .continuous))
                            .shadow(color: selectedColor.opacity(value), radius: (80 * value))
                            .frame(width: Const.shapeSize.width, height: Const.shapeSize.height)
                            .scaleEffect(x: hScale, y: vScale, anchor: anchor)
                            .offset(x: 0, y: vOffset)
                            .gesture(DragGesture(minimumDistance: 0)
                                .onChanged { drag in
                                    if !isTouching {
                                        startValue = value
                                    }
                                    isTouching = true
                                    var value = startValue - (drag.translation.height / Const.shapeSize.height)
                                    self.value = min(max(value, 0.0), 1.0)
                                    if value > 1 {
                                        value = sqrt(sqrt(sqrt(value)))
                                        anchor = .bottom
                                        vOffset = Const.shapeSize.height * (1 - value) / 2
                                    } else if value < 0 {
                                        value = sqrt(sqrt(sqrt(1 - value)))
                                        anchor = .top
                                        vOffset = -Const.shapeSize.height * (1 - value) / 2
                                    } else {
                                        value = 1.0
                                        anchor = .center
                                    }
                                    vScale = value
                                    hScale = 2 - value
                                }
                                .onEnded { _ in
                                    isTouching = false
                                    vScale = 1.0
                                    hScale = 1.0
                                    anchor = .center
                                    vOffset = 0.0
                                }
                            )
                    }
                    .frame(height: geometry.size.height * 0.9) // Adjust this value

                    Spacer(minLength: 0)

                    ColorPicker(selectedColor: $selectedColor)
                        .padding()
                }
                .animation(isTouching ? .none : .spring, value: vScale)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    @ViewBuilder
    var slider: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.gray.opacity(0.2))
            VStack {
                Spacer().frame(minHeight: 0)
                Rectangle()
                    .frame(width: Const.shapeSize.width, height: value * Const.shapeSize.height)
                    .foregroundStyle(selectedColor.gradient)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Slider()
    }
}
