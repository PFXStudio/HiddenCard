//
//  Player.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/03.
//

import Foundation

struct Player: Hashable {
    var uuid: String?
    var name: String?
    var thumbnailPhotoURL: URL?
    var photoURL: URL?
    var email: String?
    var phoneNumber: String?
    
    func toDictionary() -> [String : Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            if case Optional<Any>.none = value { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
}

func == (lhs: Player, rhs: Player) -> Bool {
    if lhs.uuid == nil || rhs.uuid == nil { return false }
    return lhs.uuid == rhs.uuid
}

