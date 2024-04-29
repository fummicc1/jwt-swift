//
//  JwtCodable+.swift
//
//
//  Created by Fumiya Tanaka on 2024/04/29.
//

import Foundation

extension JwtCodable {
	public func sign() throws -> String {
		var ret: String = ""
		let alg = header.alg.rawValue
		let typ = header.typ.rawValue
		let json = [
			"alg": alg,
			"typ": typ
		]
		let headerData = try JSONSerialization.data(withJSONObject: json)
		let headerBase64 = headerData.base64EncodedString()

		let parsedPayload = try parse(payload: payload)
		let payloadData = try JSONSerialization.data(withJSONObject: parsedPayload)
		let payloadBase64 = payloadData.base64EncodedString()

		// TODO: Implement
		let signBase64 = ""

		ret = "\(headerBase64).\(payloadBase64).\(signBase64)"

		return ret
	}

	public func parse() throws -> [String: Any] where Payload: Codable {
		let encoder = JSONEncoder()
		let data = try encoder.encode(payload)
		let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
		guard let json else {
			throw JwtCodableError.failedToParse(payload: data)
		}
		return json
	}

	public func compare(with other: some JwtCodable) throws -> Bool {
		let lhs = try sign()
		let rhs = try other.sign()
		return lhs == rhs
	}
}
