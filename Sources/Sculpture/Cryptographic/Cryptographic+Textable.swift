//
//  Cryptographic+Textable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/28/21.
//

import Foundation
import Crypto

extension CryptographicType: Textable
{
    public init?(structureText: StructureText)
    {
        guard let line = structureText.line else {return nil}
        guard line.name == "cryptographic" else {return nil}
        guard line.parameters.count == 1 else {return nil}
        switch line.parameters[0]
        {
            case "p256AgreementPublic":
                self = .p256AgreementPublic
            case "p256AgreementPrivate":
                self = .p256AgreementPrivate
            case "p256SigningPublic":
                self = .p256SigningPublic
            case "p256SigningPrivate":
                self = .p256SigningPrivate
            case "p256Signature":
                self = .p256Signature
            case "sha256":
                self = .sha256
            case "chaChaPolyKey":
                self = .chaChaPolyKey
            case "chaChaPolyNonce":
                self = .chaChaPolyNonce
            case "chaChaPolyBox":
                self = .chaChaPolyBox
            default:
                return nil
        }
    }

    public var structureText: StructureText
    {
        switch self
        {
            case .p256AgreementPublic:
                return .line(Line(name: "cryptographic", parameters: ["p265AgreemenertPublic"]))
            case .p256AgreementPrivate:
                return .line(Line(name: "cryptographic", parameters: ["p265AgreemenertPrivate"]))
            case .p256SigningPublic:
                return .line(Line(name: "cryptographic", parameters: ["p265SigningPublic"]))
            case .p256SigningPrivate:
                return .line(Line(name: "cryptographic", parameters: ["p265SigningPrivate"]))
            case .p256Signature:
                return .line(Line(name: "cryptographic", parameters: ["p265Signature"]))
            case .sha256:
                return .line(Line(name: "cryptographic", parameters: ["sha256"]))
            case .chaChaPolyKey:
                return .line(Line(name: "cryptographic", parameters: ["chaChaPolyKey"]))
            case .chaChaPolyNonce:
                return .line(Line(name: "cryptographic", parameters: ["chaChaPolyNonce"]))
            case .chaChaPolyBox:
                return .line(Line(name: "cryptographic", parameters: ["chaChaPolyBox"]))
        }
    }
}

extension CryptographicValue: Textable
{
    public init?(structureText: StructureText)
    {
        guard let line = structureText.line else {return nil}
        guard line.name == "cryptographic" else {return nil}
        guard line.parameters.count == 2 else {return nil}
        let parameter = line.parameters[1]
        guard let data = Data(hex: parameter) else {return nil}
        switch line.parameters[0]
        {
            case "p256AgreementPublic":
                guard let value = P256.KeyAgreement.PublicKey(data: data) else {return nil}
                self = .p256AgreementPublic(value)
            case "p256AgreementPrivate":
                guard let value = P256.KeyAgreement.PrivateKey(data: data) else {return nil}
                self = .p256AgreementPrivate(value)
            case "p256SigningPublic":
                guard let value = P256.Signing.PublicKey(data: data) else {return nil}
                self = .p256SigningPublic(value)
            case "p256SigningPrivate":
                guard let value = P256.Signing.PrivateKey(data: data) else {return nil}
                self = .p256SigningPrivate(value)
            case "p256Signature":
                guard let value = P256.Signing.ECDSASignature(data: data) else {return nil}
                self = .p256Signature(value)
            case "sha256":
                self = .sha256(data)
            case "chaChaPolyKey":
                let value = SymmetricKey(data: data)
                self = .chaChaPolyKey(value)
            case "chaChaPolyNonce":
                guard let value = try? ChaChaPoly.Nonce(data: data) else {return nil}
                self = .chaChaPolyNonce(value)
            case "chaChaPolyBox":
                guard let value = ChaChaPoly.SealedBox(data: data) else {return nil}
                self = .chaChaPolyBox(value)
            default:
                return nil
        }

    }

    public var structureText: StructureText
    {
        switch self
        {
            case .p256AgreementPublic(let value):
                return .line(Line(name: "cryptographic", parameters: ["p265AgreemenertPublic", value.data.hex]))
            case .p256AgreementPrivate(let value):
                return .line(Line(name: "cryptographic", parameters: ["p265AgreemenertPrivate", value.data.hex]))
            case .p256SigningPublic(let value):
                return .line(Line(name: "cryptographic", parameters: ["p265SigningPublic", value.data.hex]))
            case .p256SigningPrivate(let value):
                return .line(Line(name: "cryptographic", parameters: ["p265SigningPrivate", value.data.hex]))
            case .p256Signature(let value):
                return .line(Line(name: "cryptographic", parameters: ["p265Signature", value.data.hex]))
            case .sha256(let value):
                return .line(Line(name: "cryptographic", parameters: ["sha256", value.hex]))
            case .chaChaPolyKey(let value):
                return .line(Line(name: "cryptographic", parameters: ["chaChaPolyKey", value.data.hex]))
            case .chaChaPolyNonce(let value):
                return .line(Line(name: "cryptographic", parameters: ["chaChaPolyNonce", value.data.hex]))
            case .chaChaPolyBox(let value):
                return .line(Line(name: "cryptographic", parameters: ["chaChaPolyBox", value.data.hex]))
        }
    }
}
