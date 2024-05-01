//
//  JwtCodable+.swift
//
//
//  Created by Fumiya Tanaka on 2024/04/29.
//

import Foundation
import Collections

extension JwtCodable {
	public func sign(secret: String) throws -> String {
		var ret: String = ""
		let alg = header.alg.rawValue
		let typ = header.typ.rawValue
		let headerDict: OrderedDictionary = [
			"alg": alg,
			"typ": typ
		]
		let json = "{" + headerDict.map { "\($0.key):\($0.value)" }.joined(separator: ",") + "}"

		let headerBase64 = json.data(using: .utf8)!.base64EncodedString()

		let parsedPayload = try parse()
		let payloadData = try JSONSerialization.data(
			withJSONObject: parsedPayload
		)
		let payloadBase64 = payloadData.base64EncodedString()

		// TODO: Implement
		ret = "\(headerBase64).\(payloadBase64)"
		let signBase64 = try makeSignature(with: secret, from: ret)

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
		print("parsed json", json)
		return json
	}

	public func compare(with other: some JwtCodable, secret: String) throws -> Bool {
		let lhs = try sign(secret: secret)
		let rhs = try other.sign(secret: secret)
		return lhs == rhs
	}
}
