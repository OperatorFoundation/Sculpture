//
//  Cryptographic+Codable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/27/21.
//

import Foundation
import Crypto

extension P256.Signing.PublicKey: Codable
{
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        try self.init(x963Representation: data)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()
        try container.encode(self.x963Representation)
    }
}

extension P256.Signing.PrivateKey: Codable
{
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        try self.init(x963Representation: data)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()
        try container.encode(self.x963Representation)
    }
}

extension P256.KeyAgreement.PublicKey: Codable
{
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        try self.init(x963Representation: data)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()
        try container.encode(self.x963Representation)
    }
}

extension P256.KeyAgreement.PrivateKey: Codable
{
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        try self.init(x963Representation: data)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()
        try container.encode(self.x963Representation)
    }
}

extension P256.Signing.ECDSASignature: Codable
{
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        try self.init(rawRepresentation: data)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawRepresentation)
    }
}

extension SymmetricKey: Codable
{
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        self.init(data: data)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()

        try self.withUnsafeBytes
        {
            pointer in

            let data = Data(bytes: pointer.baseAddress!, count: pointer.count)
            try container.encode(data)
        }
    }
}

extension ChaChaPoly.Nonce: Codable
{
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        try self.init(data: data)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()

        try self.withUnsafeBytes
        {
            pointer in

            let data = Data(bytes: pointer.baseAddress!, count: pointer.count)
            try container.encode(data)
        }
    }
}

extension ChaChaPoly.SealedBox: Codable
{
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        try self.init(combined: data)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()

        try self.nonce.withUnsafeBytes
        {
            pointer in

            var combined = Data()
            let nonceData = Data(bytes: pointer.baseAddress!, count: pointer.count)
            combined.append(nonceData)
            combined.append(self.ciphertext)
            combined.append(self.tag)

            try container.encode(combined)
        }
    }
}
