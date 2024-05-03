//
//  JwtCodableTests.swift
//  
//
//  Created by Fumiya Tanaka on 2024/05/01.
//

import XCTest
@testable import JwtSwift

struct JwtExample: JwtPayload {
	let sub: String
	let name: String
	let iat: Double
}

final class JwtCodableTests: XCTestCase {
	func test_jwt_conversion() throws {
		let secret = "my-secret"
		let sut = Jwt(
			header: .init(
				alg: .hs256,
				typ: .jwt
			),
			payload: JwtExample(
				sub: "1234567890",
				name: "John Doe",
				iat: 1516239022
			)
		)
		let verified = try sut.verify(with: secret)
		XCTAssertTrue(verified)
	}
}
