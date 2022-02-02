//
//  StructureMaybeDatable.swift
//
//  Created by Dr. Brandon Wiley on 9/30/21.
//

import Foundation
import Datable

let version: UInt8 = 0

public enum Entities: UInt8
{
    case type     = 100
    case value    = 200
    case flow     = 150
    case relation = 160
}

public enum Types: UInt8
{
    // Types
    case basic         = 101
    case structure     = 102
    case choice        = 103
    case sequence      = 104
    case function      = 106
    case selector      = 107
    case interface     = 108
    case tuple         = 109
    case optional      = 110
    case cryptographic = 120
}

public enum Values: UInt8
{
    // Values
    case basic         = 201
    case choice        = 202
    case function      = 203
    case optional      = 204
    case sequence      = 205
    case structure     = 206
    case tuple         = 207
    case cryptographic = 220
}

public enum Flows: UInt8
{
    case call   = 151
    case result = 152
}

public enum Relations: UInt8
{
    case inherits     = 161
    case implements   = 162
    case encapsulates = 163
}

public enum References: UInt8
{
    case literal   = 251
    case reference = 252
    case named     = 253
}

enum BasicTypes: UInt8
{
    case int     = 11
    case uint    = 12
    case string  = 13
    case bytes   = 14
    case boolean = 15
    case float   = 16
}

enum Optionals: UInt8
{
    case value = 90
    case empty = 91
}

enum Results: UInt8
{
    case value   = 80
    case failure = 81
}

enum CryptographicTypes: UInt8
{
    case p256AgreementPublic  = 121
    case p256AgreementPrivate = 122
    case p256SigningPublic    = 123
    case p256SigningPrivate   = 124
    case p256Signature        = 125
    case sha256               = 126
    case chaChaPolyKey        = 127
    case chaChaPolyNonce      = 128
    case chaChaPolyBox        = 129
}

enum CryptographicValues: UInt8
{
    case p256AgreementPublic  = 221
    case p256AgreementPrivate = 222
    case p256SigningPublic    = 223
    case p256SigningPrivate   = 224
    case p256Signature        = 225
    case sha256               = 226
    case chaChaPolyKey        = 227
    case chaChaPolyNonce      = 228
    case chaChaPolyBox        = 229
}

public func countDataToCount(_ data: Data) -> UInt64?
{
    guard data.count == 8 else {return nil}
    return data.maybeNetworkUint64
}

func stringToData(_ string: String) -> Data
{
    let data = string.data
    let countData = dataToCountData(data)

    return countData + data
}

func sliceDataToString(_ data: Data) -> (String, Data)?
{
    guard data.count >= 8 else {return nil}

    let countBytes = Data(data[0..<8])
    guard let countUint64 = countDataToCount(countBytes) else {return nil}
    let count = Int(countUint64)

    guard data.count >= count+8 else {return nil}
    let stringData = Data(data[8..<count+8])
    let string = stringData.string

    let restOffset = count + 8
    let restSlice = data[restOffset...]
    let rest = Data(restSlice)

    return (string, rest)
}

func sliceData(_ data: Data) -> (Data, Data)?
{
    guard data.count >= 8 else {return nil}

    let countBytes = Data(data[0..<8])
    guard let countUint64 = countDataToCount(countBytes) else {return nil}
    let count = Int(countUint64)

    guard data.count >= count+8 else {return nil}
    let stringData = Data(data[8..<count+8])

    let restOffset = count + 8
    let restSlice = data[restOffset...]
    let rest = Data(restSlice)

    return (stringData, rest)
}

func sliceDataToUInt64(_ data: Data) -> (UInt64, Data)?
{
    guard data.count >= 8 else {return nil}

    let countBytes = Data(data[0..<8])
    guard let countUint64 = countDataToCount(countBytes) else {return nil}

    let restSlice = data[8...]
    let rest = Data(restSlice)

    return (countUint64, rest)
}

func listToData<T>(_ list: [T], totalCount: Bool = false, itemCount: Bool = false) -> Data where T: MaybeDatable
{
    var result = Data()

    for item in list
    {
        let data = item.data

        if itemCount
        {
            let countData = dataToCountData(data)
            result.append(countData)
        }

        result.append(data)
    }

    if totalCount
    {
        let countData = dataToCountData(result)
        return countData + result
    }
    else
    {
        return result
    }
}

func listToDataNoCount<T>(_ list: [T]) -> Data where T: MaybeDatable
{
    var result = Data()

    for item in list
    {
        let data = item.data
        result.append(data)
    }

    return result
}

func sliceDataToList<T>(_ data: Data) -> ([T], Data)? where T: MaybeDatable
{
    guard data.count >= 8 else {return nil}

    let countBytes = Data(data[0..<8])
    guard let countUint64 = countDataToCount(countBytes) else {return nil}
    let count = Int(countUint64)

    guard data.count >= count+8 else {return nil}
    let listData = Data(data[8..<count+8])

    let restOffset = count + 8
    let restSlice = data[restOffset...]
    let rest = Data(restSlice)

    guard let list: [T] = dataToList(listData) else {return nil}

    return (list, rest)
}

func dataToList<T>(_ data: Data) -> [T]? where T: MaybeDatable
{
    var results: [T] = []

    guard var (item, rest): (T, Data) = sliceDataToListItem(data) else {return nil}
    results.append(item)

    while rest.count > 0
    {
        guard let sliced: (T, Data) = sliceDataToListItem(rest) else {return nil}
        (item, rest) = sliced
        results.append(item)
    }

    return results
}

func sliceDataToListItem<T>(_ data: Data) -> (T, Data)? where T: MaybeDatable
{
    guard data.count >= 8 else {return nil}

    let countBytes = Data(data[0..<8])
    guard let countUint64 = countDataToCount(countBytes) else {return nil}
    let count = Int(countUint64)

    guard data.count >= count+8 else {return nil}
    let itemData = Data(data[8..<count+8])
    guard let item = T(data: itemData) else {return nil}

    let restOffset = count + 8
    let restSlice = data[restOffset...]
    let rest = Data(restSlice)

    return (item, rest)
}

func sliceDataToEnumChoiceData(_ data: Data) -> (Data, Data)?
{
    guard data.count >= 8 else {return nil}

    let countBytes = Data(data[0..<8])
    guard let countUint64 = countDataToCount(countBytes) else {return nil}
    let count = Int(countUint64)

    guard data.count >= count+8 else {return nil}
    let itemData = Data(data[8..<count+8])

    let restOffset = count + 8
    let restSlice = data[restOffset...]
    let rest = Data(restSlice)

    return (itemData, rest)
}

public func dataToCountData(_ data: Data) -> Data
{
    let count = data.count
    let countUint64 = UInt64(count)
    return countUint64.maybeNetworkData!
}

extension Entity: MaybeDatable
{
    public init?(data: Data)
    {
        let countBytes = Data(data[0..<8])
        guard let count = countDataToCount(countBytes) else {return nil}

        let rest = Data(data[8...])

        // Length check failed, data is corrupted
        guard rest.count == count else {return nil}

        let typeByte = rest[0]
        let remainder = Data(rest[1...])

        guard let type = Entities(rawValue: typeByte) else {return nil}
        switch type
        {
            case .type:
                guard let type = Type(data: remainder) else {return nil}
                self = .type(type)
            case .value:
                guard let value = Value(data: remainder) else {return nil}
                self = .value(value)
            case .flow:
                guard let value = Flow(data: remainder) else {return nil}
                self = .flow(value)
            case .relation:
                guard let value = Relation(data: remainder) else {return nil}
                self = .relation(value)
        }
    }

    public var data: Data
    {
        switch self
        {
            case .type(let type):
                let data = Entities.type.rawValue.data + type.data
                let countData = dataToCountData(data)
                return countData + data
            case .value(let value):
                let data = Entities.value.rawValue.data + value.data
                let countData = dataToCountData(data)
                return countData + data
            case .flow(let value):
                let data = Entities.flow.rawValue.data + value.data
                let countData = dataToCountData(data)
                return countData + data
            case .relation(let value):
                let data = Entities.relation.rawValue.data + value.data
                let countData = dataToCountData(data)
                return countData + data
        }
    }
}
