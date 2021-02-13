//
//  SignUpActionableItem.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/01.
//

import RxSwift

public protocol SignUpActionableItem: class {
    func launchHome() -> Observable<(SignUpActionableItem, ())>
}
