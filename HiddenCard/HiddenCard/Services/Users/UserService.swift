//
//  UserService.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/04/17.
//

import Foundation
import Firebase
import RxSwift

protocol ProfileServiceable {
    func updateProfile(player: Player) -> Single<Void>
}

struct UserService {
    let database: DatabaseReference
}

extension UserService: ProfileServiceable {
    func updateProfile(player: Player) -> Single<Void> {
        guard let uuid = player.uuid else {
            return Single.never()
        }
        
        return Single<Void>.create { single -> Disposable in
            self.database.ref.child("users").child(uuid).setValue(player.toDictionary())
            single(.success(()))
            return Disposables.create()
        }
    }
}
