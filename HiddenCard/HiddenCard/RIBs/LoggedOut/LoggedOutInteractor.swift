//
//  LoggedOutInteractor.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser

protocol LoggedOutRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.\
    func showKakaoLogin()
}

protocol LoggedOutListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func routeToSignUp(player: Player)
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>, LoggedOutInteractable, LoggedOutPresentableListener {
    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?
    private let profileService: ProfileServiceable
    private let signUpActionableItemSubject = ReplaySubject<SignUpActionableItem>.create(bufferSize: 1)

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: LoggedOutPresentable, profileService: ProfileServiceable) {
        self.profileService = profileService
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
        self.presenter.showKakaoLogin()
    }
    func requestSignUp() {
        
    }
    
    func requestProfile() {
        
    }
    
    func requestSignUp(player: Player) {
        guard let _ = player.uuid else {
            self.presenter.showKakaoLogin()
            return
        }

        self.listener?.routeToSignUp(player: player)
    }
    
    private func requestProfile() -> Single<Player> {
        Single<Player>.create { single -> Disposable in
            UserApi.shared.me { (user, error) in
                if let _ = error {
                    single(.error(HCError.invalidUser(func: #function, line: #line)))
                    return
                }
                
                guard let userId = user?.id else {
                    single(.error(HCError.invalidUser(func: #function, line: #line)))
                    return
                }
                
                guard let profile = user?.kakaoAccount?.profile else {
                    single(.error(HCError.invalidProfile(func: #function, line: #line)))
                    return
                }
                
                let uuid = Defines.kakaoUserKey + String(userId)
                print(uuid)
                let player = Player(uuid: uuid, name: profile.nickname, thumbnailPhotoURL: profile.thumbnailImageUrl, photoURL: profile.profileImageUrl, email: nil, phoneNumber: nil)
                single(.success(player))
            }
            return Disposables.create()
        }
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



