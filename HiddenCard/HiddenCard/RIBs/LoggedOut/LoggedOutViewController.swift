//
//  LoggedOutViewController.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs
import RxSwift
import UIKit
import TextureSwiftSupport
import FirebaseUI
import RxCocoa
import RxCocoa_Texture

protocol LoggedOutPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class LoggedOutViewController: ASDKViewController<ASDisplayNode>, LoggedOutPresentable, LoggedOutViewControllable {
    weak var listener: LoggedOutPresentableListener?
    
    private lazy var singupNode = { () -> ASButtonNode in
        let node = ASButtonNode()
        node.setAttributedTitle(NSAttributedString(string: "signupButton", attributes: Self.defaultButtonAttributes), for: .normal)
        node.clipsToBounds = true
        
        
    }
    override init() {
        super.init(node: ASDisplayNode())
        self.title = "LoggedOut"
        self.node.onDidLoad { node in
        }
    }
    
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
        self.present(authViewController, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
