//
//  RootActionableItem.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/01.
//

import RxSwift

public protocol RootActionableItem: class {
    func waitForAuth() -> Observable<(LoggedOutActionableItem, ())>
    func waitForSignUp() -> Observable<(SignUpActionableItem, ())>
}
