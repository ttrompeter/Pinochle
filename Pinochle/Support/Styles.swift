//
//  Styles.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import SwiftUI

struct FunctionsButtonStyle: ButtonStyle {
    private struct ContentView<Content: View>: View {
        @Environment(\.isEnabled) private var isEnabled
        var view: Content
        var body: some View {
            view
                .padding()
                .frame(width: 140, height: 40)
                .background(Color(.tan))
                .foregroundColor(isEnabled ? Color(.racinggreen) : Color(.slate))
                .font(.callout)
                .clipShape(Capsule())
                .opacity(isEnabled ? 1.0 : 0.5)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ContentView(view: configuration.label)
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct LargeButtonStyle: ButtonStyle {
    private struct ContentView<Content: View>: View {
        @Environment(\.isEnabled) private var isEnabled
        var view: Content
        var body: some View {
            view
                .padding()
                .frame(width: 220, height: 60)
                .background(Color(.tan))
                .foregroundColor(isEnabled ? Color(.racinggreen) : Color(.slate))
                .font(.title3)
                .clipShape(Capsule())
                .opacity(isEnabled ? 1.0 : 0.6)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ContentView(view: configuration.label)
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PhoneButtonStyle: ButtonStyle {
    private struct ContentView<Content: View>: View {
        @Environment(\.isEnabled) private var isEnabled
        var view: Content
        var body: some View {
            view
                .padding()
                .frame(width: 94, height: 25)
                .background(Color(.tan))
                .foregroundColor(isEnabled ? Color(.racinggreen) : Color(.slate))
                .font(.caption2)
                .clipShape(Capsule())
                .opacity(isEnabled ? 1.0 : 0.6)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(Color(.brown), lineWidth: 2)
//                )
//                .padding(5)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ContentView(view: configuration.label)
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PhoneCloudsButtonStyle: ButtonStyle {
    private struct ContentView<Content: View>: View {
        @Environment(\.isEnabled) private var isEnabled
        var view: Content
        var body: some View {
            view
                //.padding(2)
                .frame(width: 92, height: 25)
                .background(isEnabled ? Color(.clouds) : Color(.white))
                .foregroundColor(isEnabled ? Color(.racinggreen) : Color(.slate))
                .font(.caption)
                .clipShape(Capsule())
                .opacity(isEnabled ? 1.0 : 0.6)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.racinggreen), lineWidth: 1.5)
                )
                .padding(2)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ContentView(view: configuration.label)
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PlayerButtonStyle: ButtonStyle {
    private struct ContentView<Content: View>: View {
        @Environment(\.isEnabled) private var isEnabled
        var view: Content
        var body: some View {
            view
                .padding()
                .frame(width: 180, height: 40)
                .background(Color(.clouds))
                .foregroundColor(isEnabled ? Color(.racinggreen) : Color(.slate))
                .font(.callout)
                .clipShape(Capsule())
                .opacity(isEnabled ? 1.0 : 0.5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.racinggreen), lineWidth: 1)
                )
                .padding(10)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ContentView(view: configuration.label)
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PlayerListButtonStyle: ButtonStyle {
    private struct ContentView<Content: View>: View {
        @Environment(\.isEnabled) private var isEnabled
        var view: Content
        var body: some View {
            view
                .padding()
                .frame(width: 180, height: 40)
                .background(Color(.clouds))
                .foregroundColor(isEnabled ? Color(.racinggreen) : Color(.slate))
                .font(.callout)
                .clipShape(Capsule())
                .opacity(isEnabled ? 1.0 : 0.5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.racinggreen), lineWidth: 1)
                )
                .padding(10)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ContentView(view: configuration.label)
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PopoverButtonStyle: ButtonStyle {
    private struct ContentView<Content: View>: View {
        @Environment(\.isEnabled) private var isEnabled
        var view: Content
        var body: some View {
            view
                .padding()
                .frame(width: 85, height: 25)
                .background(Color(.tan))
                .foregroundColor(isEnabled ? Color(.racinggreen) : Color(.slate))
                .font(.caption)
                .clipShape(Capsule())
                .opacity(isEnabled ? 1.0 : 0.6)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ContentView(view: configuration.label)
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SmallButtonStyle: ButtonStyle {
    private struct ContentView<Content: View>: View {
        @Environment(\.isEnabled) private var isEnabled
        var view: Content
        var body: some View {
            view
                .padding()
                .frame(width: 110, height: 30)
                .background(Color(.tan))
                .foregroundColor(isEnabled ? Color(.racinggreen) : Color(.slate))
                .font(.caption)
                .clipShape(Capsule())
                .opacity(isEnabled ? 1.0 : 0.6)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ContentView(view: configuration.label)
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}



