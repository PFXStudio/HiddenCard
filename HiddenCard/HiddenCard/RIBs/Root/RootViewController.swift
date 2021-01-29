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

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    var listener: RootPresentableListener?
    
    
}
