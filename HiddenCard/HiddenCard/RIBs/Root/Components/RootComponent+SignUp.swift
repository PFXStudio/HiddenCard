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
    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the SignUp scope.
}

extension RootComponent: SignUpDependency {

    // TODO: Implement properties to provide for SignUp scope.
}
