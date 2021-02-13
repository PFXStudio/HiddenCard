//
//  RootComponent+SignUp.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/04.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the SignUp scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencySignUp: Dependency {
}

extension RootComponent: SignUpDependency {
    var player: Player {
        return self.player
    }
}
