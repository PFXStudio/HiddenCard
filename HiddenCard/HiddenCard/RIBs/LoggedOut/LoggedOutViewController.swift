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

protocol LoggedOutPresentableListener: class {
    func viewWillAppear()
    func requestSignUp(player: Player)
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {
    weak var listener: LoggedOutPresentableListener?
    private var once = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if once == true { return }
        once = true
        self.listener?.viewWillAppear()
    }

    func showLogin() {
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
}

extension LoggedOutViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        let uid = authDataResult?.user.uid
        let displayName = authDataResult?.user.displayName
        let photoURL = authDataResult?.user.photoURL
        let phoneNumber = authDataResult?.user.phoneNumber
        let email = authDataResult?.user.email
        let player = Player(uuid: uid, name: displayName, photoURL: photoURL, email: email, phoneNumber: phoneNumber)
        self.listener?.requestSignUp(player: player)
    }
}
