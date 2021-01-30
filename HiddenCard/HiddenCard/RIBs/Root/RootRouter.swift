//
//  RootRouter.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs

protocol RootInteractable: Interactable, LoggedOutListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func present(destination: ViewControllable)
    func dismiss(destination: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable> {
    // TODO: Constructor inject child builder protocols to allow building children.
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouter: ViewableRouting?
    init(interactor: RootInteractable, viewController: RootViewControllable, loggedOutBuilder: LoggedOutBuildable) {
        self.loggedOutBuilder = loggedOutBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        self.routeToLoggedOut()
    }

    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }
}

extension RootRouter: RootRouting {
    func routeToLoggedOut() {
        let loggedOutRouter = self.loggedOutBuilder.build(withListener: self.interactor)
        self.loggedOutRouter = loggedOutRouter
        self.attachChild(loggedOutRouter)
        self.viewController.present(destination: loggedOutRouter.viewControllable)
    }
}
