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

	var secret: String { get }

	func sign() throws -> String
	func compare(with other: some JwtCodable) throws -> Bool
	func parse(payload: Payload) throws -> [String: Any]

	static func decode(from: String) throws -> Self
}

public enum JwtCodableError: LocalizedError {
	case failedToParse(payload: Data)
}

