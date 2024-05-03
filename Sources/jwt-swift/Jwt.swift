//
//  Jwt.swift
//
//
//  Created by Fumiya Tanaka on 2024/04/29.
//

import Foundation

public protocol JwtPayload: Codable, Equatable {
	static var encoder: JSONEncoder { get }
	static var decoder: JSONDecoder { get }
}

extension JwtPayload {
	static var encoder: JSONEncoder { JSONEncoder() }
	static var decoder: JSONDecoder { JSONDecoder() }
}

public struct Jwt<Payload: JwtPayload> {

	// MARK: Required
	public var header: JwtHeader
	public var payload: Payload
	public var signature: String?

	public init(header: JwtHeader, payload: Payload, signature: String? = nil) {
		self.header = header
		self.payload = payload
		self.signature = signature
	}

	public init(header: JwtHeader, payload: Payload, secret: String) {
		self.header = header
		self.payload = payload
		self.signature = try? encode(with: secret)
	}
}

public enum JwtError: LocalizedError {
	case failedToDecodeHeader(base64: String)
	case failedToDecodePayload(base64: String)
}

