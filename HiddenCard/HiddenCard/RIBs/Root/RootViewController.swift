//
//  RootViewController.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/01/29.
//

import RIBs
import UIKit

protocol RootPresentableListener: class {
    func viewDidAppear()
}

final class RootViewController: UIViewController, RootPresentable {
    weak var listener: RootPresentableListener?
    private var targetViewController: ViewControllable?
    private var animationInProgress = false
    private var once = false
}

extension RootViewController: RootViewControllable {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if once == true { return }
        self.listener?.viewDidAppear()
        once = true
    }
    
    func replaceModal(viewController: ViewControllable?) {
        targetViewController = viewController

        guard !animationInProgress else {
            return
        }

        if presentedViewController != nil {
            animationInProgress = true
            dismiss(animated: true) { [weak self] in
                if self?.targetViewController != nil {
                    self?.presentTargetViewController()
                } else {
                    self?.animationInProgress = false
                }
            }
        } else {
            presentTargetViewController()
        }
    }

    private func presentTargetViewController() {
        if let targetViewController = targetViewController {
            animationInProgress = true
            present(targetViewController.uiviewController, animated: true) { [weak self] in
                self?.animationInProgress = false
            }
        }
    }
}
