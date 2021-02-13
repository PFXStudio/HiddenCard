//
//  LoggedOutActionableItem.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/01.
//

import RxSwift

public protocol LoggedOutActionableItem: class {
    func waitForSignUp() -> Observable<(SignUpActionableItem, ())>
}
