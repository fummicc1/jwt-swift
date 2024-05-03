//
//  JwtHeader.swift
//
//
//  Created by Fumiya Tanaka on 2024/04/29.
//

import Foundation

public struct JwtHeader: Equatable, Codable {
	public let alg: Alg
	public let typ: Typ
}

extension JwtHeader {
	public enum Alg: String, Codable {
		case hs256 = "HS256"
	}
	public enum Typ: String, Codable {
		case jwt = "JWT"
	}
}
