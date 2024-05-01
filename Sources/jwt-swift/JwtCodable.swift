//
//  JwtCodable.swift
//
//
//  Created by Fumiya Tanaka on 2024/04/29.
//

import Foundation

public protocol JwtCodable {
	associatedtype Payload

	var header: JwtHeader { get }
	var payload: Payload { get }

	func sign(secret: String) throws -> String
	func compare(with other: some JwtCodable, secret: String) throws -> Bool
	func parse() throws -> [String: Any]

	static func decode(from: String, secret: String) throws -> Self
}

public enum JwtCodableError: LocalizedError {
	case failedToParse(payload: Data)
}

