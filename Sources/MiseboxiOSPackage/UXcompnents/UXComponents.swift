//  File.swift
//
//
//  Created by Daniel Watson on 23.01.24.
//

import Foundation
import SwiftUI

// MARK: - UXComponents View (for Preview)

public struct UXComponents: View {
    @State private var int = 0
    @State private var string = "sample"

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Atoms").font(.headline).padding(.top)
                // Atom Components
                CustomLabel(text: "Sample Label", style: .primary)
                CustomTextField(placeholder: "Primary Text Field", text: $string, style: .primary)
                CustomButton(title: "Primary Button", action: {}, style: .primary)
                CustomButton(title: "Icon Button", action: {
                }, style: .primary, iconName: "plus.circle.fill")

                CustomSecureField(placeholder: "Password", text: $string, style: .primary)
                TimePickerComponent(label: "Hour", selection: $int, range: 0...23, style: StyleType.forTimeType(.start)) // Included as an atom
                
                Text("Molecules").font(.headline).padding(.top)
                // Molecule Components
                TimePicker(selectedHour: $int, selectedMinute: $int, startOrFinish: .end)

                Text("Organisms").font(.headline).padding(.top)
                // Organism Components
            }
        }
    }
}


// MARK: - Atoms
// These are the basic building blocks of the UI.

public struct CustomLabel: View {
    var text: String
    var style: StyleType

    public var body: some View {
        Text(text)
            .modifier(CustomLabelStyle(style: style))
    }
}

public struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var style: StyleType

    public var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(CustomTextFieldStyle(style: style.style))
    }
}

public struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    var style: StyleType

    public var body: some View {
        SecureField(placeholder, text: $text)
            .textFieldStyle(CustomTextFieldStyle(style: style.style))
    }
}

public struct CustomButton: View {
    var title: String
    var action: () -> Void
    var style: StyleType
    var iconName: String? // Optional icon name

    public var body: some View {
        Button(action: action) {
            HStack {
                if let iconName = iconName {
                    Image(systemName: iconName) // Display the icon if provided
                        .font(.title)
                }
                Text(title)
                    .fontWeight(.bold)
            }
        }
        .buttonStyle(CustomButtonStyle(style: style.style))
    }
}

public struct TimePickerComponent: View {
    var label: String
    @Binding var selection: Int
    var range: ClosedRange<Int>
    var step: Int = 1 // Step parameter reintroduced
    var style: Style

    public var body: some View {
        Picker(label, selection: $selection) {
            ForEach(range, id: \.self) { index in
                Text("\(index * step)")
                    .tag(index)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(width: 60, height: 100)
        .background(style.backgroundColor.opacity(0.8))
        .cornerRadius(style.cornerRadius)
        .shadow(radius: style.shadowRadius)
    }
}

// MARK: - Molecules
// These are combinations of one or more atoms.

public struct TimePicker: View {
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    var startOrFinish: TimeType

    public var body: some View {
        HStack(spacing: 10) {
            TimePickerComponent(
                label: "Hour",
                selection: $selectedHour,
                range: 0...23,
                step: 1, // Step for hours
                style: StyleType.forTimeType(startOrFinish) // Style based on startOrFinish
            )
            TimePickerComponent(
                label: "Minute",
                selection: $selectedMinute,
                range: 0...59,
                step: 15, // Step for minutes
                style: StyleType.forTimeType(startOrFinish) // Same style for minutes
            )
        }
    }
}

// MARK: - Supporting Structures, Enums, Styles

public struct Style {
    let foregroundColor: Color
    let backgroundColor: Color
    let shadowRadius: CGFloat = 5
    let cornerRadius: CGFloat = 5

    // Initialize with default values for shadow radius and corner radius
    public init(foregroundColor: Color, backgroundColor: Color) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
}

public enum StyleType {
    case primary, secondary

    public var style: Style {
        switch self {
        case .primary:
            return Style(
                foregroundColor: Color("PrimaryColour"),
                backgroundColor: Color("SecondaryColour")
            )
        case .secondary:
            return Style(
                foregroundColor: Color("SecondaryColour"),
                backgroundColor: Color("PrimaryColour")
            )
        }
    }
}

extension StyleType {
    public static func forTimeType(_ timeType: TimeType) -> Style {
        switch timeType {
        case .start:
            return Style(
                foregroundColor: Color.green,
                backgroundColor: Color.green.opacity(0.2)
            )
        case .end:
            return Style(
                foregroundColor: Color.red,
                backgroundColor: Color.red.opacity(0.2)
            )
        }
    }
}

public struct CustomLabelStyle: ViewModifier {
    var style: StyleType

    public func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .foregroundColor(style.style.foregroundColor)
            .padding()
            .cornerRadius(style.style.cornerRadius)
    }
}

public struct CustomButtonStyle: ButtonStyle {
    var style: Style

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(style.foregroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .shadow(radius: style.shadowRadius)
            .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

public struct CustomTextFieldStyle: TextFieldStyle {
    var style: Style

    public func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .shadow(radius: style.shadowRadius)
            .padding(.horizontal)
    }
}

public enum TimeType {
    case start, end
}

public struct AvatarView: View {
    var imageUrl: String
    var width: CGFloat
    var height: CGFloat
    var onSelect: () -> Void
    var hasNewContent: Bool = true

    public var notificationRing: some View {
        Group {
            if hasNewContent {
                Circle()
                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: width * 0.05)
            } else {
                Circle()
                    .stroke(Color.black, lineWidth: 1)
            }
        }
        .frame(width: width + (hasNewContent ? width * 0.05 : 1) * 2, height: height + (hasNewContent ? height * 0.05 : 1) * 2)
    }

    public var asyncImage: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable().scaledToFill()
            case .failure:
                Image(systemName: "exclamationmark.triangle").resizable().scaledToFit().foregroundColor(.red)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: width, height: height)
        .clipShape(Circle())
        .shadow(color: .gray, radius: 1, x: 0, y: 0) // Sharper shadow
    }

    public var body: some View {
        Button(action: onSelect) {
            ZStack {
                notificationRing
                asyncImage
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
