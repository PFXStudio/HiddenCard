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
    private let loggedOutBuilder: LoggedOutBuildable
    // TODO : 대체 왜... 이것만 있으면 릭남
    private var current: ViewableRouting?

    private let signUpBuilder: SignUpBuildable
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
        self.detachCurrent()
        let values = self.loggedOutBuilder.build(withListener: self.interactor)
        self.attachChild(values.router)
        self.current = values.router
        self.viewController.replaceModal(viewController: values.router.viewControllable)
        return values.actionableItem
    }
    
    
    func routeToSignUp(player: Player) -> SignUpActionableItem {
        self.detachCurrent()
        let values = self.signUpBuilder.build(withListener: self.interactor)
        self.attachChild(values.router)
        self.viewController.replaceModal(viewController: values.router.viewControllable)
        return values.actionableItem
    }
    
    private func detachCurrent() {
        if let router = self.current {
            detachChild(router)
            viewController.replaceModal(viewController: nil)
            self.current = nil
        }
    }
}
