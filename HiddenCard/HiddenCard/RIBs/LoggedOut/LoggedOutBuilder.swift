//
//  LoggedOutBuilder.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs

protocol LoggedOutDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class LoggedOutComponent: Component<LoggedOutDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol LoggedOutBuildable: Buildable {
    func build(withListener listener: LoggedOutListener) -> (router: LoggedOutRouting, actionableItem: LoggedOutActionableItem)
}

final class LoggedOutBuilder: Builder<LoggedOutDependency>, LoggedOutBuildable {

    override init(dependency: LoggedOutDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedOutListener) -> (router: LoggedOutRouting, actionableItem: LoggedOutActionableItem) {
        let viewController = UIStoryboard(name: "LoggedOut", bundle: nil).instantiateViewController(withIdentifier: String(describing: LoggedOutViewController.self)) as! LoggedOutViewController
        let interactor = LoggedOutInteractor(presenter: viewController)
        interactor.listener = listener
        let router = LoggedOutRouter(interactor: interactor, viewController: viewController)
        return (router, interactor)
    }
}
