//
//  SignUpBuilder.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/01.
//

import RIBs

protocol SignUpDependency: Dependency {
    var player: Player { get }
}

final class SignUpComponent: Component<SignUpDependency> {
    fileprivate var player: Player {
        return dependency.player
    }
}

// MARK: - Builder

protocol SignUpBuildable: Buildable {
    func build(withListener listener: SignUpListener) -> (router: SignUpRouting, actionableItem: SignUpActionableItem)
}

final class SignUpBuilder: Builder<SignUpDependency>, SignUpBuildable {

    override init(dependency: SignUpDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SignUpListener) -> (router: SignUpRouting, actionableItem: SignUpActionableItem) {
        let component = SignUpComponent(dependency: dependency)
        let viewController = SignUpViewController()
        viewController.modalPresentationStyle = .fullScreen
        let interactor = SignUpInteractor(presenter: viewController, player: component.player)
        interactor.listener = listener
        return (SignUpRouter(interactor: interactor, viewController: viewController), interactor)
    }
}
