//
//  SignUpInteractor.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/01.
//

import RIBs
import RxSwift

protocol SignUpRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SignUpPresentable: Presentable {
    var listener: SignUpPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SignUpListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SignUpInteractor: PresentableInteractor<SignUpPresentable>, SignUpInteractable, SignUpPresentableListener {

    weak var router: SignUpRouting?
    weak var listener: SignUpListener?
    private let actionableItemSubject = ReplaySubject<SignUpActionableItem>.create(bufferSize: 1)

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SignUpPresentable) {
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
    
    deinit {
        
    }
}

extension SignUpInteractor: SignUpActionableItem {
    func launchHome() -> Observable<(SignUpActionableItem, ())> {
        return self.actionableItemSubject
            .map { (item: SignUpActionableItem) -> (SignUpActionableItem, ()) in
                return (item, ())
            }
    }
}
