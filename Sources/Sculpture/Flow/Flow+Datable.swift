//
//  Flow+Datable.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/28/21.
//

import Foundation
import Datable

extension Flow: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}

        let typeByte = data[0]
        guard let type = Flows(rawValue: typeByte) else {return nil}

        let rest = Data(data[1...])

        switch type
        {
            case .call:
                guard let value = Call(data: rest) else {return nil}
                self = .call(value)
            case .result:
                guard let value = Result(data: rest) else {return nil}
                self = .result(value)
        }
    }

    public var data: Data
    {
        switch self
        {
            case .call(let value):
                return Flows.call.rawValue.data + value.data
            case .result(let value):
                return Flows.result.rawValue.data + value.data
        }
    }
}

extension Call: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (identifier, rest) = sliceDataToUInt64(data) else {return nil}
        self.identifier = identifier

        guard let (target, remainder): (Value, Data) = sliceDataToListItem(rest) else {return nil}
        self.target = target

        guard let (selector, left): (Selector, Data) = sliceDataToListItem(remainder) else {return nil}
        self.selector = selector

        guard let (arguments, _): ([Value], Data)  = sliceDataToList(left) else {return nil}
        self.arguments = arguments
    }

    public var data: Data
    {
        var result = Data()

        guard let identifierData = self.identifier.maybeNetworkData else {return Data()}
        result.append(identifierData)

        result.append(dataToCountData(self.target.data))
        result.append(self.target.data)

        result.append(dataToCountData(self.selector.data))
        result.append(self.selector.data)

        result.append(listToData(self.arguments, totalCount: true, itemCount: true))

        return result
    }
}

extension Result: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (identifier, rest) = sliceDataToUInt64(data) else {return nil}
        self.identifier = identifier

        guard let value = ResultValue(data: rest) else {return nil}
        self.value = value
    }

    public var data: Data
    {
        var result = Data()

        guard let identifierData = self.identifier.maybeNetworkData else {return Data()}
        result.append(identifierData)
        result.append(self.value.data)

        return result
    }
}

extension ResultValue: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}

        let typeByte = data[0]
        guard let type = Results(rawValue: typeByte) else {return nil}

        let rest = Data(data[1...])

        switch type
        {
            case .value:
                guard let value = Value(data: rest) else {return nil}
                self = .value(value)
            case .failure:
                self = .failure
        }
    }

    public var data: Data
    {
        switch self
        {
            case .value(let value):
                return Results.value.rawValue.data + value.data
            case .failure:
                return Results.failure.rawValue.data
        }
    }
}
