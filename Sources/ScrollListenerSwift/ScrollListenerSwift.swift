//
//  ListenerScrollSwift.swift
//  
//
//  Created by Pierre Gourgouillon on 05/12/2022.
//

import SwiftUI
import Combine

public struct ScrollListener<Content: View>: View {

    @Environment(\.onScrollCallback) private var onScroll
    @Environment(\.onScrollFinishCallback) private var onScrollEnd

    @ViewBuilder private var content: Content

    private let axes: Axis.Set
    private let showsIndicators: Bool

    private var scrollDetector: CurrentValueSubject<CGFloat, Never>
    private var scrollPublisher: AnyPublisher<CGFloat, Never>
    private var scrollEndDetector: CurrentValueSubject<CGFloat, Never>
    private var scrollEndPublisher: AnyPublisher<CGFloat, Never>

    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        delayToPerformWhenScrollFinish: Double = 0.1,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content()
        self.axes = axes
        self.showsIndicators = showsIndicators

        let scrollDetector = CurrentValueSubject<CGFloat, Never>(0)
        self.scrollPublisher = scrollDetector
            .debounce(for: .seconds(0), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
        self.scrollDetector = scrollDetector

        let scrollEndDetector = CurrentValueSubject<CGFloat, Never>(0)
        self.scrollEndPublisher = scrollEndDetector
            .debounce(for: .seconds(delayToPerformWhenScrollFinish), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
        self.scrollEndDetector = scrollEndDetector
    }

    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content
            .background(
                GeometryReader {
                    Color.clear.preference(
                        key: ViewOffsetKey.self,
                        value: axes == .horizontal ?
                            -$0.frame(in: .named("scroll")).origin.x :
                            -$0.frame(in: .named("scroll")).origin.y
                    )
                }
            )
            .onPreferenceChange(ViewOffsetKey.self) { value in
                scrollDetector.send(value)
                scrollEndDetector.send(value)
            }
        }
        .coordinateSpace(name: "scroll")
        .onReceive(scrollPublisher) {
            guard let onScroll = onScroll, $0 != 0.0 else { return }

            onScroll($0)
        }
        .onReceive(scrollEndPublisher) {
            guard let onScrollEnd = onScrollEnd else { return }

            onScrollEnd($0)
        }
    }
}

private struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct ListenerScrollSwift_Previews: PreviewProvider {
    static var previews: some View {
        ScrollListener {
            ForEach(0..<10) { _ in
                Text("Hello")
                    .foregroundColor(.red)
            }
        }
    }
}
