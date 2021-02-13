//
//  LaunchSignUpWorkflow.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/01.
//

import RIBs
import RxSwift

public class LaunchSignUpWorkFlow: Workflow<RootActionableItem> {
    public init(url: URL) {
        super.init()
        self.onStep { (rootItem: RootActionableItem) -> Observable<(LoggedOutActionableItem, ())> in
            rootItem.waitForAuth()
        }
        .onStep { (loggedOutItem: LoggedOutActionableItem, _) -> Observable<(SignUpActionableItem, ())> in
            loggedOutItem.waitForSignUp()
        }
        .onStep { (signUpItem: SignUpActionableItem, _) -> Observable<(SignUpActionableItem, ())> in
            signUpItem.launchHome()
        }
        .commit()
    }
}
