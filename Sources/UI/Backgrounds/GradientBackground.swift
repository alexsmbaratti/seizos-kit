//
//  AccentGradientBackground.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/22/25.
//

public struct GradientBackground: ViewModifier {
    private let color: Color
    
    @Environment(\.colorScheme) private var colorScheme
#if os(watchOS)
    @Environment(\.isLuminanceReduced) private var isLuminanceReduced
#endif
    
    public init(color: Color) {
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        content
#if os(visionOS)
        // visionOS should not use gradient backgrounds
#elseif os(watchOS)
            .background(
                Group {
                    if !isLuminanceReduced {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(0.5),
                                color.opacity(0.2)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                }
                    .ignoresSafeArea()
            )
#else
            .background(
                Group {
                    if #available(iOS 26.0, macOS 26.0) {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(colorScheme == .light ? 1 : 0.5),
                                Color.clear
                            ]),
                            startPoint: .top,
                            endPoint: .center
                        )
                    }
                }
                    .ignoresSafeArea(edges: [.top, .leading, .trailing])
            )
#endif
    }
}

public extension View {
    /// Applies a platform-adaptive accent gradient background to the view.
    ///
    /// watchOS will have the gradient take up the entire screen.
    /// visionOS will not have a gradient applied to match visionOS aesthetics.
    /// Other platforms (iOS, macOS) will have the gradient take up about half of the screen.
    ///
    /// - Parameter color: The base color of the gradient.
    /// - Returns: A view with the accent gradient background applied.
    func gradientBackground(color: Color) -> some View {
        self.modifier(GradientBackground(color: color))
    }
}
