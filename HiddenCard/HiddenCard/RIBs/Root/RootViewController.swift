//
//  RootViewController.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs
import UIKit

protocol RootPresentableListener: class {
    
}

final class RootViewController: UIViewController, RootPresentable {
    var listener: RootPresentableListener?
}

extension RootViewController: RootViewControllable {
    func dismiss(destination: ViewControllable, completion: @escaping () -> ()) {
        if presentedViewController === destination.uiviewController {
            dismiss(animated: true) {
                completion()
            }
        }
    }
    
    func present(destination: ViewControllable) {
        self.present(destination.uiviewController, animated: true, completion: nil)
    }
}
