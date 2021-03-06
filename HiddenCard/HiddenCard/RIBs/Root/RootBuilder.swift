//
//  RootBuilder.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs

protocol RootDependency: Dependency {
}

final class RootComponent: Component<RootDependency> {
    let rootViewController: RootViewController
    init(dependency: RootDependency, rootViewcontroller: RootViewController) {
        self.rootViewController = rootViewcontroller
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> (router: LaunchRouting, UrlHandler: UrlHandler)
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> (router: LaunchRouting, UrlHandler: UrlHandler) {
        let viewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: String(describing: RootViewController.self)) as! RootViewController
        let component = RootComponent(dependency: dependency, rootViewcontroller: viewController)
        let interactor = RootInteractor(presenter: viewController)
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let signUpBuilder = SignUpBuilder(dependency: component)
        let router = RootRouter(interactor: interactor, viewController: viewController,
                          loggedOutBuilder: loggedOutBuilder, signUpBuilder: signUpBuilder)
        return (router, interactor)
    }
}
