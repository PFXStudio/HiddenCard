//
//  LoggedOutViewController.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs
import RxSwift
import UIKit
import FirebaseUI
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser
import AsyncDisplayKit

protocol LoggedOutPresentableListener: class {
    func viewWillAppear()
    func requestSignUp(player: Player)
}

final class LoggedOutViewController: ASDKViewController<ASDisplayNode>, LoggedOutPresentable, LoggedOutViewControllable {
    weak var listener: LoggedOutPresentableListener?
    var disposeBag = DisposeBag()
    private var once = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if once == true { return }
        once = true
        self.listener?.viewWillAppear()
    }
    
    private func canKakaoLogin() -> Single<Void> {
        Single<Void>.create { single -> Disposable in
            if AuthApi.isKakaoTalkLoginAvailable() == false {
                single(.error(HCError.invalidKakaoTalk(func: #function, line: #line)))
                return Disposables.create()
            }
            
            single(.success(()))
            return Disposables.create()
        }
    }
    
    private func requestKakaoLogin() -> Single<OAuthToken> {
        Single<OAuthToken>.create { single -> Disposable in
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let _ = error {
                    single(.error(HCError.invalidSystem(func: #function, line: #line)))
                    return
                }
                
                guard let token = oauthToken else {
                    single(.error(HCError.invalidUser(func: #function, line: #line)))
                    return
                }
                single(.success(token))
            }
            return Disposables.create()
        }
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
    
    func showKakaoLogin() {
        self.canKakaoLogin()
            .map(self.requestKakaoLogin)
            .flatMap({ token -> Single<Player> in
                self.requestProfile()
            })
            .subscribe(onSuccess: { player in
                // TODO :
            }, onError: { error in
                guard let error = error as? HCError else { return }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func showGoogleLogin() {
        
        guard let auth = FUIAuth.defaultAuthUI() else { return }
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(authUI: auth),
            //                FUIFacebookAuth(authUI: auth),
            FUIPhoneAuth(authUI:auth),
        ]
        auth.providers = providers
        
        let authViewController = auth.authViewController()
        auth.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: false, completion: nil)
        
    }
    
    @IBAction func tappedSignUp(_ sender: Any) {
        let player = Player(uuid: "uid", name: "displayName", photoURL: nil, email: "email", phoneNumber: "phoneNumber")
        self.listener?.requestSignUp(player: player)
    }
}

extension LoggedOutViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard let auth = FUIAuth.defaultAuthUI() else { return }
        auth.providers.removeAll()
        auth.delegate = nil
        let uid = authDataResult?.user.uid
        let displayName = authDataResult?.user.displayName
        let photoURL = authDataResult?.user.photoURL
        let phoneNumber = authDataResult?.user.phoneNumber
        let email = authDataResult?.user.email
        let player = Player(uuid: uid, name: displayName, photoURL: photoURL, email: email, phoneNumber: phoneNumber)
        self.listener?.requestSignUp(player: player)
    }
}
