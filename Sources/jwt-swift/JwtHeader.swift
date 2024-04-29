//
//  JwtHeader.swift
//
//
//  Created by Fumiya Tanaka on 2024/04/29.
//

import Foundation

public struct JwtHeader {
	public let alg: Alg
	public let typ: Typ
}

extension JwtHeader {
	public enum Alg: String {
		case hs256 = "HS256"
	}
	public enum Typ: String {
		case jwt = "JWT"
	}
}
