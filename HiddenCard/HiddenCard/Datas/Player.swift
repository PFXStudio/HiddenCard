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
    var photoURL: URL?
    var email: String?
    var phoneNumber: String?
}

func == (lhs: Player, rhs: Player) -> Bool {
    if lhs.uuid == nil || rhs.uuid == nil { return false }
    return lhs.uuid == rhs.uuid
}

