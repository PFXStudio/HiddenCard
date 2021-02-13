//
//  SignUpViewController.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/01.
//

import RIBs
import RxSwift
import UIKit
import TextureSwiftSupport

protocol SignUpPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    var load: AnyObserver<Void> { get }
    
    var displayData: Observable<Player> { get }
}

final class SignUpViewController: ASDKViewController<ASTableNode>, SignUpPresentable, SignUpViewControllable {
    private let disposeBag = DisposeBag()
    weak var listener: SignUpPresentableListener?
    
    override init() {
        let tableNode = ASTableNode(style: .plain)
        tableNode.backgroundColor = .cyan
        tableNode.automaticallyManagesSubnodes = true
        super.init(node: tableNode)
        self.node.onDidLoad { node in
            guard let node = node as? ASTableNode else { return }
            node.view.separatorStyle = .none
        }
        
        self.node.leadingScreensForBatching = 2.0
        self.node.dataSource = self
        self.node.delegate = self
        self.node.allowsSelectionDuringEditing = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        self.listener?.displayData
            .asDriver(onErrorJustReturn: Player())
            .drive(onNext: { [weak self] driver in
                guard let self = self else { return }
            })
            .disposed(by: self.disposeBag)
        self.listener?.load.onNext(())
            
    }
}

extension SignUpViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 4
    }
}

extension SignUpViewController: ASTableDelegate {
    
}
