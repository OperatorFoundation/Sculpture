//
//  File.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/6/21.
//

import Foundation
import Datable

extension Type: MaybeDatable
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
                guard let value = LiteralType(data: rest) else {return nil}
                self = .literal(value)
            case .reference:
                guard let value = ReferenceType(data: rest) else {return nil}
                self = .reference(value)
            case .named:
                guard let value = NamedReferenceType(data: rest) else {return nil}
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

extension LiteralType: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}

        let typeByte = data[0]
        guard let type = Types(rawValue: typeByte) else {return nil}

        let rest = Data(data[1...])

        switch type
        {
            case .basic:
                guard let value = BasicType(data: rest) else {return nil}
                self = .basic(value)
            case .cryptographic:
                guard let value = CryptographicType(data: rest) else {return nil}
                self = .cryptographic(value)
            case .structure:
                guard let value = Structure(data: rest) else {return nil}
                self = .structure(value)
            case .choice:
                guard let value = Choice(data: rest) else {return nil}
                self = .choice(value)
            case .sequence:
                guard let value = Sequence(data: rest) else {return nil}
                self = .sequence(value)
            case .function:
                guard let value = FunctionSignature(data: rest) else {return nil}
                self = .function(value)
            case .selector:
                guard let value = Selector(data: rest) else {return nil}
                self = .selector(value)
            case .interface:
                guard let value = Interface(data: rest) else {return nil}
                self = .interfaceType(value)
            case .tuple:
                guard let value = TupleType(data: rest) else {return nil}
                self = .tuple(value)
            case .optional:
                guard let value = Optional(data: rest) else {return nil}
                self = .optional(value)
        }
    }

    public var data: Data
    {
        switch self
        {
            case .basic(let value):
                return Types.basic.rawValue.data + value.data
            case .cryptographic(let value):
                return Types.cryptographic.rawValue.data + value.data
            case .structure(let value):
                return Types.structure.rawValue.data + value.data
            case .sequence(let value):
                return Types.sequence.rawValue.data + value.data
            case .choice(let value):
                return Types.choice.rawValue.data + value.data
            case .function(let value):
                return Types.function.rawValue.data + value.data
            case .selector(let value):
                return Types.selector.rawValue.data + value.data
            case .interfaceType(let value):
                return Types.interface.rawValue.data + value.data
            case .tuple(let value):
                return Types.tuple.rawValue.data + value.data
            case .optional(let value):
                return Types.optional.rawValue.data + value.data
        }
    }
}

extension Structure: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (name, rest) = sliceDataToString(data) else {return nil}
        self.name = name

        guard let properties: [Property] = dataToList(rest) else
        {
            self.properties = []
            return
        }
        self.properties = properties
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.name))
        result.append(listToData(self.properties, totalCount: false, itemCount: true))

        return result
    }
}

extension Option: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (name, rest) = sliceDataToString(data) else {return nil}
        self.name = name

        guard let typeList: [Type] = dataToList(rest) else
        {
            self.types = []
            return
        }

        self.types = typeList
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.name))
        result.append(listToData(self.types, totalCount: false, itemCount: true))

        return result
    }
}

extension Property: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (name, rest) = sliceDataToString(data) else {return nil}
        self.name = name

        guard let type = Type(data: rest) else {return nil}
        self.type = type
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.name))
        result.append(self.type.data)

        return result
    }
}

extension Sequence: MaybeDatable
{
    public init?(data: Data)
    {
        guard let type = Type(data: data) else {return nil}
        self.type = type
    }

    public var data: Data
    {
        return self.type.data
    }
}

extension Choice: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (name, rest) = sliceDataToString(data) else {return nil}
        self.name = name

        guard let optionList: [Option] = dataToList(rest) else
        {
            self.options = []
            return
        }

        self.options = optionList
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.name))
        result.append(listToData(self.options, totalCount: false, itemCount: true))

        return result
    }
}

//extension PropertyType: MaybeDatable
//{
//    public init?(data: Data)
//    {
//        guard data.count > 1 else {return nil}
//
//        let typeByte = data[0]
//        let rest = Data(data[1...])
//        guard let type = Types(rawValue: typeByte) else {return nil}
//
//        switch type
//        {
//            case .basic:
//                guard let basicType = BasicType(data: rest) else {return nil}
//                self = .basic(basicType)
//            case .structure:
//                let typeName = rest.string
//                self = .structure(typeName)
//            case .sequence:
//                let typeName = rest.string
//                self = .sequence(typeName)
//            case .choice:
//                let typeName = rest.string
//                self = .choice(typeName)
//            default:
//                return nil
//        }
//    }
//
//    public var data: Data
//    {
//        var result = Data()
//
//        switch self
//        {
//            case .basic(let basicType):
//                result.append(Types.basic.rawValue.data)
//                result.append(basicType.data)
//            case .structure(let typeName):
//                result.append(Types.structure.rawValue.data)
//                result.append(typeName.data)
//            case .sequence(let typeName):
//                result.append(Types.sequence.rawValue.data)
//                result.append(typeName.data)
//            case .choice(let typeName):
//                result.append(Types.choice.rawValue.data)
//                result.append(typeName.data)
//        }
//
//        return result
//    }
//}

extension BasicType: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count == 1 else {return nil}

        let byte = data[0]
        guard let type = BasicTypes(rawValue: byte) else {return nil}

        switch type
        {
            case .string:
                self = .string
            case .uint:
                self = .uint
            case .int:
                self = .int
            case .bytes:
                self = .bytes
            case .boolean:
                self = .boolean
            case .float:
                self = .float
        }
    }

    public var data: Data
    {
        switch self
        {
            case .string:
                return BasicTypes.string.rawValue.data
            case .int:
                return BasicTypes.int.rawValue.data
            case .uint:
                return BasicTypes.uint.rawValue.data
            case .bytes:
                return BasicTypes.bytes.rawValue.data
            case .boolean:
                return BasicTypes.boolean.rawValue.data
            case .float:
                return BasicTypes.float.rawValue.data
        }
    }
}

extension FunctionSignature: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (parameters, rest): ([Type], Data) = sliceDataToList(data) else {return nil}
        self.parameters = parameters

        if rest.count > 0
        {
            guard let result = Type(data: rest) else {return nil}
            self.result = result
        }
        else
        {
            self.result = nil
        }
    }

    public var data: Data
    {
        var bytes = Data()

        bytes.append(listToData(self.parameters, totalCount: true, itemCount: true))

        if let result = self.result
        {
            bytes.append(result.data)
        }

        return bytes
    }
}

extension NamedFunction: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (name, rest) = sliceDataToString(data) else {return nil}
        self.name = name

        guard let signature = FunctionSignature(data: rest) else {return nil}
        self.signature = signature
    }

    public var data: Data
    {
        var bytes = Data()

        bytes.append(stringToData(self.name))
        bytes.append(self.signature.data)

        return bytes
    }
}

extension Interface: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (name, rest) = sliceDataToString(data) else {return nil}
        self.name = name

        guard let functions: [NamedFunction] = dataToList(rest) else {return nil}
        self.functions = functions
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.name))
        result.append(listToData(self.functions, totalCount: false, itemCount: true))

        return result
    }
}

extension TupleType: MaybeDatable
{
    public init?(data: Data)
    {
        guard let parts: [Type] = dataToList(data) else {return nil}
        self.parts = parts
    }

    public var data: Data
    {
        return listToData(self.parts, totalCount: false, itemCount: true)
    }
}

extension Optional: MaybeDatable
{
    public init?(data: Data)
    {
        guard let type = Type(data: data) else {return nil}
        self.type = type
    }

    public var data: Data
    {
        return type.data
    }
}

extension ReferenceType: MaybeDatable
{
    public init?(data: Data)
    {
        guard let identifier = UInt64(maybeNetworkData: data) else {return nil}
        self.identifier = identifier

        guard let _ = TypeDatabase.get(identifier: self.identifier) else {return nil}
    }

    public var data: Data
    {
        return self.identifier.data
    }
}

extension NamedReferenceType: MaybeDatable
{
    public init?(data: Data)
    {
        self.name = data.string

        guard let _ = NamedTypeDatabase.get(name: self.name) else {return nil}
    }

    public var data: Data
    {
        return self.name.data
    }
}

extension Selector: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (name, rest) = sliceDataToString(data) else {return nil}
        self.name = name

        guard let signature = FunctionSignature(data: rest) else {return nil}
        self.signature = signature
    }

    public var data: Data
    {
        var data = Data()

        data.append(stringToData(self.name))
        data.append(self.signature.data)

        return data
    }
}
