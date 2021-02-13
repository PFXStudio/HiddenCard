//
//  LoggedOutInteractor.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs
import RxSwift
import FirebaseUI

protocol LoggedOutRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.\
    func showLogin()
}

protocol LoggedOutListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func routeToSignUp(player: Player)
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>, LoggedOutInteractable, LoggedOutPresentableListener {
    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?
    private let signUpActionableItemSubject = ReplaySubject<SignUpActionableItem>.create(bufferSize: 1)

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: LoggedOutPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func viewWillAppear() {
        self.presenter.showLogin()
    }

    func requestSignUp(player: Player) {
        guard let _ = player.uuid else {
            self.presenter.showLogin()
            return
        }

        self.listener?.routeToSignUp(player: player)
    }
}

extension LoggedOutInteractor: LoggedOutActionableItem {
    func waitForSignUp() -> Observable<(SignUpActionableItem, ())> {
        return self.signUpActionableItemSubject
            .map { (item: SignUpActionableItem) -> (SignUpActionableItem, ()) in
                return (item, ())
            }
    }
}



