//
//  Cryptographic.swift
//  Sculpture
//
//  Created by Dr. Brandon Wiley on 11/27/21.
//

import Foundation
import Crypto

public enum CryptographicType: Codable, Equatable
{
    case p256AgreementPublic
    case p256AgreementPrivate
    case p256SigningPublic
    case p256SigningPrivate
    case p256Signature
    case sha256
    case chaChaPolyKey
    case chaChaPolyNonce
    case chaChaPolyBox
}

public enum CryptographicValue: Codable, Equatable
{
    case p256AgreementPublic(P256.KeyAgreement.PublicKey)
    case p256AgreementPrivate(P256.KeyAgreement.PrivateKey)
    case p256SigningPublic(P256.Signing.PublicKey)
    case p256SigningPrivate(P256.Signing.PrivateKey)
    case p256Signature(P256.Signing.ECDSASignature)
    case sha256(Data)
    case chaChaPolyKey(SymmetricKey)
    case chaChaPolyNonce(ChaChaPoly.Nonce)
    case chaChaPolyBox(ChaChaPoly.SealedBox)
}
