//
//  Values+Datable.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/6/21.
//

import Foundation
import Datable

extension Value: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}

        let typeByte = data[0]
        guard let type = References(rawValue: typeByte) else {return nil}

        let rest = Data(data[1...])

        switch type
        {
            case .literal:
                guard let value = LiteralValue(data: rest) else {return nil}
                self = .literal(value)
            case .reference:
                guard let value = ReferenceValue(data: rest) else {return nil}
                self = .reference(value)
            case .named:
                guard let value = NamedReferenceValue(data: rest) else {return nil}
                self = .named(value)
        }
    }

    public var data: Data
    {
        switch self
        {
            case .literal(let value):
                return References.literal.rawValue.data + value.data
            case .reference(let value):
                return References.reference.rawValue.data + value.data
            case .named(let value):
                return References.named.rawValue.data + value.data
        }
    }
}

extension LiteralValue: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}

        let typeByte = data[0]
        guard let type = Values(rawValue: typeByte) else {return nil}

        let rest = Data(data[1...])

        switch type
        {
            case .basic:
                guard let value = BasicValue(data: rest) else {return nil}
                self = .basic(value)
            case .cryptographic:
                guard let value = CryptographicValue(data: rest) else {return nil}
                self = .cryptographic(value)
            case .choice:
                guard let value = OptionValue(data: rest) else {return nil}
                self = .choice(value)
            case .function:
                guard let value = Function(data: rest) else {return nil}
                self = .function(value)
            case .optional:
                guard let value = Optional(data: rest) else {return nil}
                self = .optional(value)
            case .sequence:
                guard let value = SequenceValue(data: rest) else {return nil}
                self = .sequence(value)
            case .structure:
                guard let value = StructureInstance(data: rest) else {return nil}
                self = .structure(value)
            case .tuple:
                guard let value = Tuple(data: rest) else {return nil}
                self = .tuple(value)
        }
    }

    public var data: Data
    {
        switch self
        {
            case .basic(let value):
                return Values.basic.rawValue.data + value.data
            case .cryptographic(let value):
                return Values.cryptographic.rawValue.data + value.data
            case .structure(let value):
                return Values.structure.rawValue.data + value.data
            case .choice(let value):
                return Values.choice.rawValue.data + value.data
            case .sequence(let value):
                return Values.sequence.rawValue.data + value.data
            case .optional(let value):
                return Values.optional.rawValue.data + value.data
            case .function(let value):
                return Values.function.rawValue.data + value.data
            case .tuple(let value):
                return Values.tuple.rawValue.data + value.data
        }
    }
}

extension SequenceValue: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (type, rest) = sliceDataToString(data) else {return nil}
        self.type = type

        guard let contents: [Value] = dataToList(rest) else {return nil}
        self.contents = contents
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.type))
        result.append(listToData(self.contents, totalCount: false, itemCount: true))

        return result
    }
}

extension StructureInstance: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (type, rest) = sliceDataToString(data) else {return nil}
        self.type = type

        guard let values: [Value] = dataToList(rest) else {return nil}
        self.values = values
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.type))
        result.append(listToData(self.values, totalCount: false, itemCount: true))

        return result
    }
}

//extension PropertyValue: MaybeDatable
//{
//    public init?(data: Data)
//    {
//        guard data.count > 1 else {return nil}
//
//        let typeByte = data[0]
//        guard let type = Types(rawValue: typeByte) else {return nil}
//
//        let rest = Data(data[1...])
//
//        switch type
//        {
//            case .basic:
//                guard let value = BasicValue(data: rest) else {return nil}
//                self = .basic(value)
//            case .choice:
//                guard let value = OptionValue(data: rest) else {return nil}
//                self = .choice(value)
//            case .sequence:
//                guard let values: [PropertyValue] = dataToList(rest) else {return nil}
//                self = .sequence(values)
//            case .structure:
//                guard let value = StructureInstance(data: rest) else {return nil}
//                self = .structure(value)
//            case .function:
//                guard let value = Function(data: rest) else {return nil}
//                self = .function(value)
//            case .tuple:
//                guard let value = Tuple(data: rest) else {return nil}
//                self = .tuple(value)
//            case .optional:
//                guard let value = Optional(data: rest) else {return nil}
//                self = .optional(value)
//        }
//    }
//
//    public var data: Data
//    {
//        var result = Data()
//
//        switch self
//        {
//            case .basic(let basic):
//                result.append(Types.basic.rawValue)
//                result.append(basic.data)
//            case .structure(let instance):
//                result.append(Types.structure.rawValue)
//                result.append(instance.data)
//            case .sequence(let values):
//                result.append(Types.sequence.rawValue)
//                result.append(listToData(values))
//            case .choice(let option):
//                result.append(Types.choice.rawValue)
//                result.append(option.data)
//            case .reference(let reference):
//                result.append(Types.reference.rawValue)
//                result.append(reference.data)
//            case .optional(let optional):
//                result.append(Types.optional.rawValue)
//                result.append(optional.data)
//            case .tuple(let value):
//                result.append(Types.tuple.rawValue)
//                result.append(value.data)
//            case .function(let value):
//                result.append(Types.function.rawValue)
//                result.append(value.data)
//        }
//
//        return result
//    }
//}

extension OptionValue: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (choice, rest) = sliceDataToString(data) else {return nil}
        self.choice = choice

        guard let (chosen, remainder) = sliceDataToString(rest) else {return nil}
        self.chosen = chosen

        guard let values: [Value] = dataToList(remainder) else {return nil}
        self.values = values
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.choice))
        result.append(stringToData(self.chosen))
        result.append(listToData(self.values))

        return result
    }
}

extension BasicValue: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}
        let typeByte = data[0]
        let value = Data(data[1...])

        guard let type = BasicTypes(rawValue: typeByte) else {return nil}
        switch type
        {
            case .string:
                self = .string(value.string)
            case .uint:
                guard let uint = value.maybeNetworkUint64 else {return nil}
                self = .uint(uint)
            case .int:
                guard let int = value.int64 else {return nil} // FIXME - This is wrong, it uses local endianness
                self = .int(int)
            case .bytes:
                self = .bytes(value)
            case .boolean:
                guard value.count == 1 else {return nil}
                let byte = value[0]
                switch byte
                {
                    case 0:
                        self = .boolean(false)
                        return
                    case 1:
                        self = .boolean(true)
                        return
                    default:
                        return nil
                }
            case .float:
                guard let float = Float(data: value) else {return nil}
                self = .float(float)
        }
    }

    public var data: Data
    {
        var result = Data()

        switch self
        {
            case .string(let string):
                result.append(BasicTypes.string.rawValue.maybeNetworkData!)
                result.append(string.data)
                return result
            case .uint(let uint):
                result.append(BasicTypes.uint.rawValue.maybeNetworkData!)
                result.append(uint.maybeNetworkData!)
                return result
            case .int(let int):
                // FIXME - need maybeNetworkData for int types
                result.append(BasicTypes.int.rawValue.maybeNetworkData!)
                result.append(int.data) // FIXME this is wrong, it has local endianness
                return result
            case .bytes(let data):
                result.append(BasicTypes.bytes.rawValue.maybeNetworkData!)
                result.append(data)
                return result
            case .boolean(let bool):
                result.append(BasicTypes.boolean.rawValue.maybeNetworkData!)
                switch bool
                {
                    case true:
                        result.append(1)
                    case false:
                        result.append(0)
                }
                return result
            case .float(let float):
                result.append(BasicTypes.float.rawValue.maybeNetworkData!)
                result.append(float.data) // FIXME this is wrong, it has local endianness
                return result
        }
    }
}

extension Function: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (type, rest) = sliceDataToString(data) else {return nil}
        self.type = type

        guard let (body, _) = sliceDataToString(rest) else {return nil}
        self.body = body
    }

    public var data: Data
    {
        var data = Data()

        data.append(stringToData(self.type))
        data.append(stringToData(self.body))

        return data
    }
}

extension Tuple: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (parts, rest): ([Value], Data) = sliceDataToList(data) else {return nil}
        self.parts = parts
        self.size = self.parts.count

        guard let type = Type(data: rest) else {return nil}
        self.type = type
    }

    public var data: Data
    {
        return listToData(self.parts, totalCount: false, itemCount: true)
    }
}

extension OptionalValue: MaybeDatable
{
    public init?(data: Data)
    {
        let typeByte = data[0]
        let valueBytes = Data(data[1...])
        guard let type = Optionals(rawValue: typeByte) else {return nil}

        switch type
        {
            case .value:
                guard let value = Value(data: valueBytes) else {return nil}
                self = .value(value)
            case .empty:
                self = .empty
        }
    }

    public var data: Data
    {
        var result = Data()

        switch self
        {
            case .value(let value):
                result.append(Optionals.value.rawValue)
                result.append(value.data)
            case .empty:
                result.append(Optionals.empty.rawValue)
        }

        return result
    }
}

extension ReferenceValue: MaybeDatable
{
    public init?(data: Data)
    {
        guard let identifier = UInt64(maybeNetworkData: data) else {return nil}
        self.identifier = identifier

        guard let _ = ValueDatabase.get(identifier: self.identifier) else {return nil}
    }

    public var data: Data
    {
        guard let result = self.identifier.maybeNetworkData else {return Data()}
        return result
    }
}

extension NamedReferenceValue: MaybeDatable
{
    public init?(data: Data)
    {
        self.name = data.string

//        guard let _ = NamedValueDatabase.get(name: self.name) else {return nil}
    }

    public var data: Data
    {
        return self.name.data
    }
}
