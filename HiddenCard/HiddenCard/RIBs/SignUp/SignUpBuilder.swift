//
//  SignUpBuilder.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/01.
//

import RIBs

protocol SignUpDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SignUpComponent: Component<SignUpDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let viewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: String(describing: SignUpViewController.self)) as! SignUpViewController
        viewController.modalPresentationStyle = .fullScreen
        let interactor = SignUpInteractor(presenter: viewController)
        interactor.listener = listener
        return (SignUpRouter(interactor: interactor, viewController: viewController), interactor)
    }
}
