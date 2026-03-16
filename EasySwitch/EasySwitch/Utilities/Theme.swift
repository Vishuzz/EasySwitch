import SwiftUI

struct Theme {
    static let nbYellow = Color(red: 1.0, green: 0.94, blue: 0.7)  // Soft Pastel Yellow
    static let nbPink = Color(red: 1.0, green: 0.8, blue: 0.85)   // Soft Pastel Pink
    static let nbCyan = Color(red: 0.75, green: 0.9, blue: 1.0)   // Soft Pastel Blue
    static let nbGreen = Color(red: 0.8, green: 0.9, blue: 0.8)   // Soft Pastel Green
    static let nbPurple = Color(red: 0.9, green: 0.8, blue: 0.9)  // Soft Pastel Purple
    static let nbOrange = Color(red: 1.0, green: 0.88, blue: 0.75) // Soft Pastel Orange
    
    static let background = Color(red: 0.85, green: 0.95, blue: 0.92) // Very Pale Mint Background
    
    static let cardColors: [Color] = [nbYellow, nbPink, nbCyan, nbGreen, nbPurple, nbOrange, nbYellow, nbPink]
}

struct NeoBrutalismModifier: ViewModifier {
    var backgroundColor: Color
    var cornerRadius: CGFloat = 24
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
    }
}

extension View {
    func neoBrutalism(backgroundColor: Color, cornerRadius: CGFloat = 24) -> some View {
        self.modifier(NeoBrutalismModifier(backgroundColor: backgroundColor, cornerRadius: cornerRadius))
    }
}

struct NeoBrutalButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var cornerRadius: CGFloat = 24
    var isSelected: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isSelected ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 3)
            )
            .shadow(color: Color.black.opacity(0.1), radius: configuration.isPressed ? 2 : 6, x: 0, y: configuration.isPressed ? 2 : 4)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct DotGridPattern: View {
    var spacing: CGFloat = 30
    var dotSize: CGFloat = 3
    var dotColor: Color = Color.black.opacity(0.15) // Darker dots for contrast against green
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for x in stride(from: 0, to: geometry.size.width, by: spacing) {
                    for y in stride(from: 0, to: geometry.size.height, by: spacing) {
                        path.addEllipse(in: CGRect(x: x, y: y, width: dotSize, height: dotSize))
                    }
                }
            }
            .fill(dotColor)
        }
        .ignoresSafeArea()
    }
}
