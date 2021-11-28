//
//  File.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/27/21.
//

import Foundation
import Crypto
import Datable

extension CryptographicType: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count == 1 else {return nil}

        let byte = data[0]
        guard let type = CryptographicTypes(rawValue: byte) else {return nil}

        switch type
        {
            case .p256AgreementPublic:
                self = .p256AgreementPublic
            case .p256AgreementPrivate:
                self = .p256AgreementPrivate
            case .p256SigningPublic:
                self = .p256SigningPublic
            case .p256SigningPrivate:
                self = .p256SigningPrivate
            case .p256Signature:
                self = .p256Signature
            case .sha256:
                self = .sha256
            case .chaChaPolyKey:
                self = .chaChaPolyKey
            case .chaChaPolyNonce:
                self = .chaChaPolyNonce
            case .chaChaPolyBox:
                self = .chaChaPolyBox
        }
    }

    public var data: Data
    {
        switch self
        {
            case .p256AgreementPublic:
                return CryptographicTypes.p256AgreementPublic.rawValue.data
            case .p256AgreementPrivate:
                return CryptographicTypes.p256AgreementPrivate.rawValue.data
            case .p256SigningPublic:
                return CryptographicTypes.p256SigningPublic.rawValue.data
            case .p256SigningPrivate:
                return CryptographicTypes.p256SigningPrivate.rawValue.data
            case .p256Signature:
                return CryptographicTypes.p256Signature.rawValue.data
            case .sha256:
                return CryptographicTypes.sha256.rawValue.data
            case .chaChaPolyKey:
                return CryptographicTypes.chaChaPolyKey.rawValue.data
            case .chaChaPolyNonce:
                return CryptographicTypes.chaChaPolyNonce.rawValue.data
            case .chaChaPolyBox:
                return CryptographicTypes.chaChaPolyBox.rawValue.data
        }
    }
}

extension CryptographicValue: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}
        let typeByte = data[0]
        let value = Data(data[1...])

        guard let type = CryptographicValues(rawValue: typeByte) else {return nil}
        switch type
        {
            case .p256AgreementPublic:
                guard let key = try? P256.KeyAgreement.PublicKey(x963Representation: value) else {return nil}
                self = .p256AgreementPublic(key)
            case .p256AgreementPrivate:
                guard let key = try? P256.KeyAgreement.PrivateKey(x963Representation: value) else {return nil}
                self = .p256AgreementPrivate(key)
            case .p256SigningPublic:
                print(value.hex)
                guard let key = try? P256.Signing.PublicKey(x963Representation: value) else {return nil}
                self = .p256SigningPublic(key)
            case .p256SigningPrivate:
                guard let key = try? P256.Signing.PrivateKey(x963Representation: value) else {return nil}
                self = .p256SigningPrivate(key)
            case .p256Signature:
                guard let signature = try? P256.Signing.ECDSASignature(rawRepresentation: value) else {return nil}
                self = .p256Signature(signature)
            case .sha256:
                self = .sha256(value)
            case .chaChaPolyKey:
                let key = SymmetricKey(data: value)
                self = .chaChaPolyKey(key)
            case .chaChaPolyNonce:
                guard let nonce = try? ChaChaPoly.Nonce(data: value) else {return nil}
                self = .chaChaPolyNonce(nonce)
            case .chaChaPolyBox:
                guard let box = try? ChaChaPoly.SealedBox(combined: value) else {return nil}
                self = .chaChaPolyBox(box)
        }
    }

    public var data: Data
    {
        var result = Data()

        switch self
        {
            case .p256AgreementPublic(let key):
                result.append(CryptographicValues.p256AgreementPublic.rawValue.maybeNetworkData!)
                result.append(key.x963Representation)
                return result
            case .p256AgreementPrivate(let key):
                result.append(CryptographicValues.p256AgreementPrivate.rawValue.maybeNetworkData!)
                result.append(key.x963Representation)
                return result
            case .p256SigningPublic(let key):
                result.append(CryptographicValues.p256SigningPublic.rawValue.maybeNetworkData!)
                result.append(key.x963Representation)
                return result
            case .p256SigningPrivate(let key):
                result.append(CryptographicValues.p256SigningPrivate.rawValue.maybeNetworkData!)
                result.append(key.x963Representation)
                return result
            case .p256Signature(let signature):
                result.append(CryptographicValues.p256Signature.rawValue.maybeNetworkData!)
                result.append(signature.rawRepresentation)
                return result
            case .sha256(let data):
                result.append(CryptographicValues.sha256.rawValue.maybeNetworkData!)
                result.append(data)
                return result
            case .chaChaPolyKey(let key):
                result.append(CryptographicValues.chaChaPolyKey.rawValue.maybeNetworkData!)
                let data = key.withUnsafeBytes
                {
                    pointer -> Data in

                    let data = Data(bytes: pointer.baseAddress!, count: pointer.count)
                    return data
                }
                result.append(data)
                return result
            case .chaChaPolyNonce(let nonce):
                result.append(CryptographicValues.chaChaPolyNonce.rawValue.maybeNetworkData!)
                let data = nonce.withUnsafeBytes
                {
                    pointer -> Data in

                    let data = Data(bytes: pointer.baseAddress!, count: pointer.count)
                    return data
                }
                result.append(data)
                return result
            case .chaChaPolyBox(let box):
                result.append(CryptographicValues.chaChaPolyBox.rawValue.maybeNetworkData!)
                result.append(box.combined)
                return result
        }
    }
}

extension P256.KeyAgreement.PublicKey: MaybeDatable
{
    public init?(data: Data)
    {
        do
        {
            try self.init(x963Representation: data)
        }
        catch
        {
            return nil
        }
    }

    public var data: Data
    {
        return self.x963Representation
    }
}

extension P256.KeyAgreement.PrivateKey: MaybeDatable
{
    public init?(data: Data)
    {
        do
        {
            try self.init(x963Representation: data)
        }
        catch
        {
            return nil
        }
    }

    public var data: Data
    {
        return self.x963Representation
    }
}

extension P256.Signing.PublicKey: MaybeDatable
{
    public init?(data: Data)
    {
        do
        {
            try self.init(x963Representation: data)
        }
        catch
        {
            return nil
        }
    }

    public var data: Data
    {
        return self.x963Representation
    }
}

extension P256.Signing.PrivateKey: MaybeDatable
{
    public init?(data: Data)
    {
        do
        {
            try self.init(x963Representation: data)
        }
        catch
        {
            return nil
        }
    }

    public var data: Data
    {
        return self.x963Representation
    }
}

extension P256.Signing.ECDSASignature: MaybeDatable
{
    public init?(data: Data)
    {
        do
        {
            try self.init(rawRepresentation: data)
        }
        catch
        {
            return nil
        }
    }

    public var data: Data
    {
        return self.rawRepresentation
    }
}

extension SymmetricKey: MaybeDatable
{
    public var data: Data
    {
        let result = self.withUnsafeBytes
        {
            pointer -> Data in

            return Data(bytes: pointer.baseAddress!, count: pointer.count)
        }

        return result
    }
}

extension ChaChaPoly.Nonce
{
    public var data: Data
    {
        let result = self.withUnsafeBytes
        {
            pointer -> Data in

            return Data(bytes: pointer.baseAddress!, count: pointer.count)
        }

        return result
    }
}

extension ChaChaPoly.SealedBox: MaybeDatable
{
    public init?(data: Data)
    {
        do
        {
            try self.init(combined: data)
        }
        catch
        {
            return nil
        }
    }

    public var data: Data
    {
        return self.combined
    }
}
