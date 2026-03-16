import SwiftUI

struct Theme {
    static let nbYellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    static let nbPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    static let nbCyan = Color(red: 0.2, green: 0.8, blue: 1.0)
    static let nbGreen = Color(red: 0.4, green: 0.9, blue: 0.4)
    static let nbPurple = Color(red: 0.7, green: 0.5, blue: 1.0)
    static let nbOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let background = Color(red: 0.95, green: 0.95, blue: 0.9)
    
    static let cardColors: [Color] = [nbYellow, nbPink, nbCyan, nbGreen, nbPurple, nbOrange]
}

struct NeoBrutalismModifier: ViewModifier {
    var backgroundColor: Color
    var cornerRadius: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: 3)
            )
            .shadow(color: .black, radius: 0, x: 4, y: 4)
    }
}

extension View {
    func neoBrutalism(backgroundColor: Color, cornerRadius: CGFloat = 0) -> some View {
        self.modifier(NeoBrutalismModifier(backgroundColor: backgroundColor, cornerRadius: cornerRadius))
    }
}

struct NeoBrutalButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var cornerRadius: CGFloat = 0
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: 3)
            )
            .shadow(color: .black, radius: 0, x: configuration.isPressed ? 0 : 4, y: configuration.isPressed ? 0 : 4)
            .offset(x: configuration.isPressed ? 4 : 0, y: configuration.isPressed ? 4 : 0)
    }
}

struct DotGridPattern: View {
    var spacing: CGFloat = 30
    var dotSize: CGFloat = 3
    var dotColor: Color = Color.blue.opacity(0.2)
    
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
