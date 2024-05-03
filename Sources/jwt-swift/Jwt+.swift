//
//  JwtCodable+.swift
//
//
//  Created by Fumiya Tanaka on 2024/04/29.
//

import Foundation

extension Jwt {
	public func encode(with secret: String) throws -> String {
		var ret: String = ""
		let encoder = JSONEncoder()
		let headerData = try encoder.encode(header)
		let headerBase64 = headerData
			.base64EncodedString()
			.convertToBase64URLEncoding()

		let payloadData = try encodePayload()
		let payloadBase64 = payloadData.base64EncodedString().convertToBase64URLEncoding()

		ret = "\(headerBase64).\(payloadBase64)"
		let signBase64 = try makeSignature(with: secret, from: ret)

		ret = "\(headerBase64).\(payloadBase64).\(signBase64)"

		return ret
	}

	public func encodePayload() throws -> Data {
		let data = try Payload.encoder.encode(payload)
		return data
	}

	public static func decode(_ token: String) throws -> Self {
		let parts = token.components(separatedBy: ".")
		assert(parts.count == 3, "Invalid jwt token")
		guard let headerData = Data(
			base64Encoded: parts[0].convertToBase64Encoding()
		) else {
			throw JwtError.failedToDecodeHeader(
				base64: parts[0].convertToBase64Encoding()
			)
		}
		let header = try JSONDecoder().decode(JwtHeader.self, from: headerData)
		guard let payloadData = Data(
			base64Encoded: parts[1].data(using: .utf8)!
		) else {
			throw JwtError.failedToDecodePayload(
				base64: parts[1].convertToBase64Encoding()
			)
		}
		let payload = try Payload.decoder.decode(Payload.self, from: payloadData)
		let signature = parts[2]
		return .init(
			header: header,
			payload: payload,
			signature: signature
		)
	}

	public func verify(with secret: String) throws -> Bool {
		let encoded = try encode(with: secret)
		let decoded = try Self.decode(encoded)
		let actualHeader = header
		let actualPayload = payload
		return decoded.header == actualHeader && decoded.payload == actualPayload
	}
}

extension String {
	func convertToBase64URLEncoding() -> String {
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

	func convertToBase64Encoding() -> String {
		replacingOccurrences(
			of: "-",
			with: "+"
		)
		.replacingOccurrences(
			of: "_",
			with: "/"
		)
	}
}
