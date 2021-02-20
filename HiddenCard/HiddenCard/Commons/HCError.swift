//
//  HCError.swift
//  HiddenCard
//
//  Created by PFXStudio on 2021/02/20.
//

import Foundation

enum HCError: Error {
    case invalidSystem(func: String, line: Int)
    case invalidKakaoTalk(func: String, line: Int)
    case invalidUser(func: String, line: Int)
    case invalidProfile(func: String, line: Int)
}

extension HCError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidSystem: return "invalid_system"
        case .invalidKakaoTalk: return "invalid_kakaotalk"
        case .invalidUser: return "invalid_user"
        case .invalidProfile: return "invalid_profile"
        }
    }
}
