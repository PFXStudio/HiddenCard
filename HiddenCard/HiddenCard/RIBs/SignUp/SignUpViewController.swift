//
//  SignUpViewController.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/01.
//

import RIBs
import RxSwift
import UIKit

protocol SignUpPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SignUpViewController: UIViewController, SignUpPresentable, SignUpViewControllable {

    weak var listener: SignUpPresentableListener?
}
