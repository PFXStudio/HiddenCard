//
//  LoggedOutBuilder.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs
import FirebaseDatabase

protocol LoggedOutDependency: Dependency {
    var player: Player { get }
}

final class LoggedOutComponent: Component<LoggedOutDependency> {
    fileprivate var player: Player {
        return dependency.player
    }
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
        let interactor = LoggedOutInteractor(presenter: viewController, profileService: UserService(database: Database.database().reference()))
        interactor.listener = listener
        let router = LoggedOutRouter(interactor: interactor, viewController: viewController)
        return (router, interactor)
    }
}
