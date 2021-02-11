//
//  RootRouter.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs

protocol RootInteractable: Interactable, LoggedOutListener, SignUpListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func replaceModal(viewController: ViewControllable?)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable> {
    // TODO: Constructor inject child builder protocols to allow building children.
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouter: ViewableRouting?
    private let signUpBuilder: SignUpBuildable
    private var signUpRouter: ViewableRouting?
    init(interactor: RootInteractable, viewController: RootViewControllable, loggedOutBuilder: LoggedOutBuildable, signUpBuilder: SignUpBuildable) {
        self.loggedOutBuilder = loggedOutBuilder
        self.signUpBuilder = signUpBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
    }

    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }
}

extension RootRouter: RootRouting {
    func routeToLoggedOut() -> LoggedOutActionableItem {
        let values = self.loggedOutBuilder.build(withListener: self.interactor)
        let loggedOutRouter = values.0
        let loggedOutInteractor = values.1
        self.loggedOutRouter = loggedOutRouter
        self.attachChild(loggedOutRouter)
        self.viewController.replaceModal(viewController: loggedOutRouter.viewControllable)
        return loggedOutInteractor
    }
    
    func routeToSignUp(player: Player) -> SignUpActionableItem {
        if let router = self.loggedOutRouter {
            self.detachChild(router)
            self.viewController.replaceModal(viewController: nil)
            self.loggedOutRouter = nil
        }

        let values = self.signUpBuilder.build(withListener: self.interactor)
        let signUpRouter = values.0
        self.attachChild(signUpRouter)
        self.signUpRouter = signUpRouter
        let signUpInteractor = values.1
        self.viewController.replaceModal(viewController: signUpRouter.viewControllable)
        
        return signUpInteractor
    }
}
