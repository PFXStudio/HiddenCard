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
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {
    weak var listener: LoggedOutPresentableListener?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let auth = FUIAuth.defaultAuthUI() else { return }
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(authUI: auth),
//                FUIFacebookAuth(authUI: auth),
            FUIPhoneAuth(authUI:auth),
        ]
        auth.providers = providers
        
        let authViewController = auth.authViewController()
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: false, completion: nil)
    }
}

extension LoggedOutViewController {
    static var defaultButtonAttributes = {
        return [NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
    }()
    
    static var selectedButtonAttributes = {
        return [NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
    }()
}
