//
//  RootInteractor.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs
import RxSwift
import RxRelay

protocol RootRouting: Routing {
    func cleanupViews()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToLoggedOut() -> LoggedOutActionableItem
    func routeToSignUp(player: Player) -> SignUpActionableItem
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable {
    weak var router: RootRouting?
    weak var listener: RootListener?
    private let loggedOutActionableItemSubject = PublishSubject<LoggedOutActionableItem>()
    private let signUpActionableItemSubject = PublishSubject<SignUpActionableItem>()

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func routeToLoggedOut() {
        guard let actionItem = self.router?.routeToLoggedOut() else { return }
        // TODO : 릭남
        self.loggedOutActionableItemSubject.onNext(actionItem)
    }
    
    func routeToSignUp(player: Player) {
        guard let actionItem = self.router?.routeToSignUp(player: player) else { return }
        self.signUpActionableItemSubject.onNext(actionItem)
    }
}

extension RootInteractor: RootPresentableListener {
    func viewDidAppear() {
        self.routeToLoggedOut()
    }
}

extension RootInteractor: RootActionableItem, UrlHandler {
    func waitForAuth() -> Observable<(LoggedOutActionableItem, ())> {
        return self.loggedOutActionableItemSubject
            .map { (item: LoggedOutActionableItem) -> (LoggedOutActionableItem, ()) in
                return (item, ())
            }
    }
    
    func waitForSignUp() -> Observable<(SignUpActionableItem, ())> {
        return self.signUpActionableItemSubject
            .map { (item: SignUpActionableItem) -> (SignUpActionableItem, ()) in
                return (item, ())
            }
    }
    
    func handle(_ url: URL) {
        let launchWorkFlow = LaunchSignUpWorkFlow(url: url)
        launchWorkFlow
            .subscribe(self)
            .disposeOnDeactivate(interactor: self)
    }
}
