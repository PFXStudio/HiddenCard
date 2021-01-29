//
//  RootRouter.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs

protocol RootInteractable: Interactable {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable> {
    // TODO: Constructor inject child builder protocols to allow building children.
    let loggedOutBuilder: LoggedOutBuildable
    let loggedOutRouter: ViewableRouting?
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
    }
    
}
