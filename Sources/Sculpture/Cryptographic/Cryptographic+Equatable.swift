//
//  Cryptographic+Equatable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/27/21.
//

import Foundation
import Crypto

extension P256.Signing.PublicKey: Equatable
{
    public static func == (lhs: P256.Signing.PublicKey, rhs: P256.Signing.PublicKey) -> Bool
    {
        return lhs.x963Representation == rhs.x963Representation
    }
}

extension P256.Signing.PrivateKey: Equatable
{
    public static func == (lhs: P256.Signing.PrivateKey, rhs: P256.Signing.PrivateKey) -> Bool
    {
        return lhs.x963Representation == rhs.x963Representation
    }
}

extension P256.KeyAgreement.PublicKey: Equatable
{
    public static func == (lhs: P256.KeyAgreement.PublicKey, rhs: P256.KeyAgreement.PublicKey) -> Bool
    {
        return lhs.x963Representation == rhs.x963Representation
    }
}

extension P256.KeyAgreement.PrivateKey: Equatable
{
    public static func == (lhs: P256.KeyAgreement.PrivateKey, rhs: P256.KeyAgreement.PrivateKey) -> Bool
    {
        return lhs.x963Representation == rhs.x963Representation
    }
}

extension P256.Signing.ECDSASignature: Equatable
{
    public static func == (lhs: P256.Signing.ECDSASignature, rhs: P256.Signing.ECDSASignature) -> Bool
    {
        return lhs.rawRepresentation == rhs.rawRepresentation
    }
}

extension ChaChaPoly.Nonce: Equatable
{
    public static func == (lhs: ChaChaPoly.Nonce, rhs: ChaChaPoly.Nonce) -> Bool
    {
        let lhsData = lhs.withUnsafeBytes
        {
            pointer in

            return Data(bytes: pointer.baseAddress!, count: pointer.count)
        }

        let rhsData = rhs.withUnsafeBytes
        {
            pointer in

            return Data(bytes: pointer.baseAddress!, count: pointer.count)
        }

        return lhsData == rhsData
    }
}

extension ChaChaPoly.SealedBox: Equatable
{
    public static func == (lhs: ChaChaPoly.SealedBox, rhs: ChaChaPoly.SealedBox) -> Bool
    {
        return lhs.combined == rhs.combined
    }
}
