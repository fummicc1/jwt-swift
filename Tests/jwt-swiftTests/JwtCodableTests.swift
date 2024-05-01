//
//  JwtCodableTests.swift
//  
//
//  Created by Fumiya Tanaka on 2024/05/01.
//

import XCTest
@testable import JwtSwift

final class JwtExample: JwtCodable {
	var header: JwtSwift.JwtHeader
	var payload: Payload

	init(header: JwtSwift.JwtHeader, payload: Payload) {
		self.header = header
		self.payload = payload
	}

	struct Payload: Codable {
		let sub: String
		let name: String
		let iat: Double
	}

	static func decode(from: String, secret: String) throws -> Self {
		fatalError()
	}
}

final class JwtCodableTests: XCTestCase {
	func test_jwt_conversion() throws {
		let expected = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
		let secret = "your-256-bit-secret"
		let sut = JwtExample(
			header: .init(
				alg: .hs256,
				typ: .jwt
			),
			payload: .init(
				sub: "1234567890",
				name: "John Doe",
				iat: 1516239022
			)
		)
		let actual = try sut.sign(secret: secret)
		XCTAssertEqual(actual, expected)
	}
}
