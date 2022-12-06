//
//  ListenerScrollSwift+Modifiers.swift
//  
//
//  Created by Pierre Gourgouillon on 06/12/2022.
//

import Foundation
import SwiftUI

public extension View {

    /// - Parameter perform: An action to perform when the user scroll the scrollView
    func onScroll(_ perform: @escaping (CGFloat) -> Void) -> some View {
        environment(\.onScrollCallback, perform)
    }

    /// - Parameter perform: An action to perform when the user finish to scroll the ScrollView
    func onScrollFinish(_ perform: @escaping (CGFloat) -> Void) -> some View {
        environment(\.onScrollFinishCallback, perform)
    }
}

extension EnvironmentValues {
    var onScrollCallback: ((CGFloat) -> Void)? {
        get { self[OnScrollCallbackKey.self] }
        set { self[OnScrollCallbackKey.self] = newValue }
    }

    var onScrollFinishCallback: ((CGFloat) -> Void)? {
        get { self[OnScrollFinishCallbackKey.self] }
        set { self[OnScrollFinishCallbackKey.self] = newValue }
    }
}

struct OnScrollCallbackKey: EnvironmentKey {
    static var defaultValue: ((CGFloat) -> Void)? = nil
}

struct OnScrollFinishCallbackKey: EnvironmentKey {
    static var defaultValue: ((CGFloat) -> Void)? = nil
}
