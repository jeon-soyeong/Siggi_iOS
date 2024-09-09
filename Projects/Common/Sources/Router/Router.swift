//
//  Router.swift
//  Common
//
//  Created by 전소영 on 2024/08/19.
//

import SwiftUI

@Observable public final class Router {
    public var route = NavigationPath()

    public init() { }
    
    @MainActor
    public func pushView<T: Hashable>(screen: T) {
        route.append(screen)
    }
    
    @MainActor
    public func popView() {
        route.removeLast()
    }
    
    @MainActor
    public func popView(depth: Int) {
        route.removeLast(depth)
    }
    
    @MainActor
    public func popToRootView() {
        route = NavigationPath()
    }
}
