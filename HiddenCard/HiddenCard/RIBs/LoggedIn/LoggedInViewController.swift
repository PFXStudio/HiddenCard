//
//  LoggedInViewController.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs
import RxSwift
import UIKit

protocol LoggedInPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class LoggedInViewController: UIViewController, LoggedInPresentable, LoggedInViewControllable {

    weak var listener: LoggedInPresentableListener?
}
