//
//  AppComponent.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import Foundation
import RIBs

class AppComponent: Component<EmptyComponent>, RootDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
