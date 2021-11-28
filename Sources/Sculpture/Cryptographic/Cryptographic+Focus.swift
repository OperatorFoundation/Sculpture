//
//  Cryptographic+Focus.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/28/21.
//

import Foundation
import Crypto
import Focus

extension CryptographicValue
{
    public var p256SigningPublic: P256.Signing.PublicKey?
    {
        return self.p256SigningPublicPrism.tryGet(self)
    }

    public var p256SigningPublicPrism: SimplePrism<CryptographicValue, P256.Signing.PublicKey>
    {
        SimplePrism<CryptographicValue, P256.Signing.PublicKey>(
            tryGet:
                {
                    (value: CryptographicValue) -> P256.Signing.PublicKey? in

                    switch value
                    {
                        case .p256SigningPublic(let value):
                            return value
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (value: P256.Signing.PublicKey) -> CryptographicValue in

                    return .p256SigningPublic(value)
                }
        )
    }

    public var p256Signature: P256.Signing.ECDSASignature?
    {
        return self.p256SignaturePrism.tryGet(self)
    }

    public var p256SignaturePrism: SimplePrism<CryptographicValue, P256.Signing.ECDSASignature>
    {
        SimplePrism<CryptographicValue, P256.Signing.ECDSASignature>(
            tryGet:
                {
                    (value: CryptographicValue) -> P256.Signing.ECDSASignature? in

                    switch value
                    {
                        case .p256Signature(let value):
                            return value
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (value: P256.Signing.ECDSASignature) -> CryptographicValue in

                    return .p256Signature(value)
                }
        )
    }
}
