//
//  StructureMaybeDatable.swift
//
//  Created by Dr. Brandon Wiley on 9/30/21.
//

import Foundation
import Datable

let version: UInt8 = 0

enum Entities: UInt8
{
    case type = 100
    case value = 200
}

public enum Types: UInt8
{
    // Types
    case basic     = 101
    case structure = 102
    case choice    = 103
    case sequence  = 104
    case reference = 105
}

public enum Values: UInt8
{
    // Values
    case basic     = 201
    case structure = 202
    case choice    = 203
    case sequence  = 204
}

enum BasicTypes: UInt8
{
    case int    = 10
    case uint   = 11
    case string = 12
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

    var sliced: (T, Data)? = sliceDataToListItem(data)
    while sliced != nil
    {
        guard let (item, rest) = sliced else {return nil}
        results.append(item)

        sliced = sliceDataToListItem(rest)
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

func dataToCountData(_ data: Data) -> Data
{
    let count = data.count
    let countUint64 = UInt64(count)
    return countUint64.maybeNetworkData!
}

func countDataToCount(_ data: Data) -> UInt64?
{
    guard data.count == 8 else {return nil}
    return data.maybeNetworkUint64
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
        }
    }
}
