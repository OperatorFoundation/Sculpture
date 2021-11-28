//
//  Cryptographic+Hashable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/27/21.
//

import Foundation
import Crypto

extension CryptographicValue: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        switch self
        {
            case .p256AgreementPublic(let key):
                hasher.combine(key.x963Representation)
            case .p256AgreementPrivate(let key):
                hasher.combine(key.x963Representation)
            case .p256SigningPublic(let key):
                hasher.combine(key.x963Representation)
            case .p256SigningPrivate(let key):
                hasher.combine(key.x963Representation)
            case .p256Signature(let signature):
                hasher.combine(signature.rawRepresentation)
            case .sha256(let data):
                hasher.combine(data)
            case .chaChaPolyKey(let key):
                key.withUnsafeBytes
                {
                    pointer in

                    let data = Data(bytes: pointer.baseAddress!, count: pointer.count)
                    hasher.combine(data)
                }
            case .chaChaPolyNonce(let nonce):
                nonce.withUnsafeBytes
                {
                    pointer in

                    let data = Data(bytes: pointer.baseAddress!, count: pointer.count)
                    hasher.combine(data)
                }
            case .chaChaPolyBox(let box):
                hasher.combine(box.combined)
        }
    }
}
