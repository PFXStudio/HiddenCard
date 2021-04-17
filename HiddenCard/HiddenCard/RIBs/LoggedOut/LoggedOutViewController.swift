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
    func requestSignUp()
    func requestProfile()
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
            if UserApi.isKakaoTalkLoginAvailable() == false {
                single(.error(HCError.invalidKakaoTalk(func: #function, line: #line)))
                return Disposables.create()
            }
            
            single(.success(()))
            return Disposables.create()
        }
    }
    
    private func requestKakaoLogin() -> Single<OAuthToken> {
        Single<OAuthToken>.create { single -> Disposable in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
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
    
    func showKakaoLogin() {
        self.canKakaoLogin()
            .map(self.requestKakaoLogin)
            .subscribe(onSuccess: { [weak listener] token in
                listener?.requestSignUp()
            }, onError: { error in
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
        self.listener?.requestSignUp()
    }
}

extension LoggedOutViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard let auth = FUIAuth.defaultAuthUI() else { return }
        auth.providers.removeAll()
        auth.delegate = nil
//        let uid = authDataResult?.user.uid
//        let displayName = authDataResult?.user.displayName
//        let photoURL = authDataResult?.user.photoURL
//        let phoneNumber = authDataResult?.user.phoneNumber
//        let email = authDataResult?.user.email
//        let player = Player(uuid: uid, name: displayName, photoURL: photoURL, email: email, phoneNumber: phoneNumber)
        self.listener?.requestSignUp()
    }
}
