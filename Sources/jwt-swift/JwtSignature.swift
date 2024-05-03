//
//  JwtSignature.swift
//
//
//  Created by Fumiya Tanaka on 2024/05/01.
//

import Foundation
import CryptoKit

extension Jwt {
	package func makeSignature(with secret: String, from encoded: String) throws -> String {
		let data = encoded.data(using: .utf8)!
		switch header.alg {
		case .hs256:
			let key = SymmetricKey(data: secret.data(using: .utf8)!)
			let signature = HMAC<SHA256>.authenticationCode(
				for: data,
				using: key
			)
			let ret = Data(signature).base64EncodedString().convertToBase64URLEncoding()
			return ret
		}
	}
}
