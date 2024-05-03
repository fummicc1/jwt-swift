//
//  JwtCodable+.swift
//
//
//  Created by Fumiya Tanaka on 2024/04/29.
//

import Foundation
import Collections

extension JwtCodable {
	public func encode(with secret: String) throws -> String {
		var ret: String = ""
		let alg = header.alg.rawValue
		let typ = header.typ.rawValue
		let headerDict = [
			"alg": alg,
			"typ": typ
		]

		let headerBase64 = try JSONSerialization.data(
			withJSONObject: headerDict
		)
			.base64EncodedString()
			.replacingForBase64URLEncoding()

		let parsedPayload = try parse()
		let payloadData = try JSONSerialization.data(
			withJSONObject: parsedPayload
		)
		let payloadBase64 = payloadData.base64EncodedString().replacingForBase64URLEncoding()

		ret = "\(headerBase64).\(payloadBase64)"
		let signBase64 = try makeSignature(with: secret, from: ret)

		ret = "\(headerBase64).\(payloadBase64).\(signBase64)"

		return ret
	}

	public func parse() throws -> [String: Any] where Payload: Codable {
		let encoder = JSONEncoder()
		let data = try encoder.encode(payload)
		let json = try JSONSerialization.jsonObject(
			with: data
		) as? [String: Any]
		guard let json else {
			throw JwtCodableError.failedToParse(payload: data)
		}
		return json
	}
}

extension String {
	func replacingForBase64URLEncoding() -> String {
		replacingOccurrences(
			of: "+",
			with: "-"
		)
		.replacingOccurrences(
			of: "/",
			with: "_"
		)
		.replacingOccurrences(
			of: "=",
			with: ""
		)
	}
}
