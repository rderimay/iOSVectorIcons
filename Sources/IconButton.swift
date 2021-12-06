//
//  IconButton.swift
//  VectorIcons
//
//  Created by Quan on 02/12/2021.
//

import SwiftUI

struct IconButton: View {
    struct Fill {
        var color: Color
        var highlightedColor: Color
        var size: CGSize!
        var cornerRadius: CGFloat
        var borderWidth: CGFloat
        var borderColor: Color
        
        init(color: Color = .white,
             highlightedColor: Color = .gray,
             size: CGSize? = nil,
             cornerRadius: CGFloat = 8,
             borderWidth: CGFloat = 1,
             borderColor: Color = .black) {
            self.color = color
            self.highlightedColor = highlightedColor
            self.size = size
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.borderColor = borderColor
        }
    }
    
    let icon: IconFont
    let size: CGFloat
    let color: Color
    let fill: Fill!
    let action: () -> Void

    public init(_ icon: IconFont,
                size: CGFloat = 16,
                color: Color = .black,
                fill: Fill? = nil,
                action: @escaping () -> Void) {
        self.icon = icon
        self.size = size
        self.color = color
        self.fill = fill
        self.action = action
        
        if !FontRegistering.shared.isRegistered {
            FontRegistering.shared.registerFonts()
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(icon.text)
                .font(Font.custom(icon.fontName, size: size))
                .foregroundColor(color)
        }
        .if(fill?.size != nil) {
            $0.frame(width: fill.size.width, height: fill.size.height)
        }
        .if(fill != nil) {
            $0.buttonStyle(
                HighlightedButtonStyle(backgroundColor: fill.color,
                                       underlayColor: fill.highlightedColor,
                                       cornerRadius: fill.cornerRadius,
                                       borderColor: fill.borderColor,
                                       borderWidth: fill.borderWidth)
            )
        }
    }
}

private struct HighlightedButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let underlayColor: Color
    let cornerRadius: CGFloat
    let borderColor: Color
    let borderWidth: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? underlayColor : backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
    }
}

private extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
