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
    
}

protocol SignUpListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SignUpInteractor: PresentableInteractor<SignUpPresentable>, SignUpInteractable {
    weak var router: SignUpRouting?
    weak var listener: SignUpListener?
    private let actionableItemSubject = ReplaySubject<SignUpActionableItem>.create(bufferSize: 1)
    private var loadSubject = PublishSubject<Void>()
    private var displayDataSubject = PublishSubject<Player>()
    private var player: Player

    init(presenter: SignUpPresentable, player: Player) {
        self.player = player
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.displayDataSubject.onNext(self.player)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension SignUpInteractor: SignUpPresentableListener {
    var displayData: Observable<(Player)> {
        return self.displayDataSubject.asObservable()
    }
    
    var load: AnyObserver<Void> {
        return self.loadSubject.asObserver()
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
