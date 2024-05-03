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
		let expected = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiSm9obiBEb2UiLCJzdWIiOiIxMjM0NTY3ODkwIiwiaWF0IjoxNTE2MjM5MDIyfQ.QZ_lxdrCXm0-53ATrihpQfr4bMDBjjKZ8tZUrWhibEg"
		let secret = "my-secret"
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
		let actual = try sut.encode(with: secret)
		XCTAssertEqual(actual, expected)
	}
}
