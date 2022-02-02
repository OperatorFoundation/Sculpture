//
//  Symbol.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/14/22.
//

import Foundation
import Datable

public enum Symbols: UInt8, MaybeDatable
{
    case word = 11
    case index = 12

    public var data: Data
    {
        return self.rawValue.data
    }

    public init?(data: Data)
    {
        guard let uint8 = data.uint8 else {return nil}
        self.init(rawValue: uint8)
    }
}

public enum Symbol: Codable, Equatable, Hashable, MaybeDatable
{
    case word(Word)
    case index(Index)

    public init?(_ string: String)
    {
        if let index = Index(string)
        {
            self = .index(index)
        }
        else if let word = Word(string)
        {
            self = .word(word)
        }
        else
        {
            return nil
        }
    }

    public var data: Data
    {
        var result = Data()

        switch self
        {
            case .word(let word):
                result.append(Symbols.word.data)
                result.append(word.data)
            case .index(let index):
                result.append(Symbols.index.data)
                result.append(index.data)
        }

        return result
    }

    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}
        let typeData = Data(data[0..<1])
        let rest = Data(data[1...])

        guard let type = Symbols(data: typeData) else {return nil}
        switch type
        {
            case .word:
                guard let word = Word(data: rest) else {return nil}
                self = .word(word)
                return
            case .index:
                guard let index = Index(data: rest) else {return nil}
                self = .index(index)
                return
        }
    }
}

public enum AtomicValues: UInt8, MaybeDatable
{
    case number = 31
    case word = 32
    case data = 33

    public var data: Data
    {
        return self.rawValue.data
    }

    public init?(data: Data)
    {
        guard let uint8 = data.uint8 else {return nil}
        self.init(rawValue: uint8)
    }
}

public enum AtomicValue: Equatable, CustomStringConvertible
{
    case number(Number)
    case word(Word)
    case data(Data)

    public var number: Number?
    {
        switch self
        {
            case .number(let number):
                return number
            default: return nil
        }
    }

    public var word: Word?
    {
        switch self
        {
            case .word(let word):
                return word
            default: return nil
        }
    }

    public var data: Data?
    {
        switch self
        {
            case .data(let data):
                return data
            default: return nil
        }
    }

    public var description: String
    {
        switch self
        {
            case .number(let number):
                return number.string
            case .word(let word):
                return word.string
            case .data(let data):
                return "0x"+data.hex
        }
    }

    public var string: String
    {
        switch self
        {
            case .number(let number):
                return number.string
            case .word(let word):
                return word.string
            case .data(let data):
                return "0x"+data.hex
        }
    }

    public init?(_ string: String)
    {
        if let number = Number(string)
        {
            self = .number(number)
        }
        else if let word = Word(string)
        {
            self = .word(word)
        }
        else
        {
            guard let unescaped = unescape(string) else {return nil}
            self = .data(unescaped.data)
        }
    }
}

public struct Number: Equatable, MaybeDatable
{
    public let string: String

    public init?(_ string: String)
    {
        // Must start with a digit or -
        let regexp = #"^-?[0-9][0-9,]*\.?[0-9]*e?-?[0-9]*$"#
        guard string.range(of: regexp, options: .regularExpression) != nil else
        {
            return nil
        }

        self.string = string
    }

    public var data: Data
    {
        var result = Data()

        let stringData = string.data
        let count = stringData.count
        let uint8 = UInt8(count)
        let countData = uint8.data

        result.append(countData)
        result.append(stringData)

        return result
    }

    public init?(data: Data)
    {
        guard data.count > 0 else {return nil}
        let countData = Data(data[0..<1])
        guard let uint8 = countData.uint8 else {return nil}
        let count = Int(uint8)

        guard count > 0 else {return nil}
        let rest = Data(data[1...])

        guard count == rest.count else {return nil}

        let string = rest.string
        self.init(string)
    }
}

public struct Word: Codable, Hashable, Equatable
{
    public let string: String

    public init?(_ string: String)
    {
        // Can't start with a digit
        let regexp = #"^[A-Za-z][A-Za-z0-9_\.]*$"#
        guard string.range(of: regexp, options: .regularExpression) != nil else
        {
            return nil
        }

        self.string = string
    }

    public var data: Data
    {
        var result = Data()

        let stringData = string.data
        let count = stringData.count
        let uint8 = UInt8(count)
        let countData = uint8.data

        result.append(countData)
        result.append(stringData)

        return result
    }

    public init?(data: Data)
    {
        guard data.count > 0 else {return nil}
        let countData = Data(data[0..<1])
        guard let uint8 = countData.uint8 else {return nil}
        let count = Int(uint8)

        guard count > 0 else {return nil}
        let rest = Data(data[1...])

        guard count == rest.count else {return nil}

        let string = rest.string
        self.init(string)
    }
}

public struct Index: Codable, Equatable, Hashable
{
    public let string: String
    public let uint64: UInt64
    public let int: Int

    public init?(_ int: Int)
    {
        self.int = int
        self.uint64 = UInt64(int)
        self.string = int.string
    }

    public init(_ uint64: UInt64)
    {
        self.uint64 = uint64
        self.int = Int(self.uint64)
        self.string = self.uint64.string
    }

    public init?(_ string: String)
    {
        // Must start with a digit or -
        let regexp = #"^\d+$"#
        guard string.range(of: regexp, options: .regularExpression) != nil else
        {
            return nil
        }

        self.string = string
        self.uint64 = UInt64(string: string)
        self.int = Int(self.uint64)
    }

    public var data: Data
    {
        var result = Data()

        let stringData = string.data
        let count = stringData.count
        let uint8 = UInt8(count)
        let countData = uint8.data

        result.append(countData)
        result.append(stringData)

        return result
    }

    public init?(data: Data)
    {
        guard data.count > 0 else {return nil}
        let countData = Data(data[0..<1])
        guard let uint8 = countData.uint8 else {return nil}
        let count = Int(uint8)

        guard count > 0 else {return nil}
        let rest = Data(data[1...])

        guard count == rest.count else {return nil}

        let string = rest.string
        self.init(string)
    }
}

extension Symbol
{
    public var word: Word?
    {
        get
        {
            switch self
            {
                case .word(let word):
                    return word
                default:
                    return nil
            }
        }

        set(newValue)
        {
            if let value = newValue
            {
                self = .word(value)
            }
        }
    }

    public var index: Index?
    {
        get
        {
            switch self
            {
                case .index(let index):
                    return index
                default:
                    return nil
            }
        }

        set(newValue)
        {
            if let value = newValue
            {
                self = .index(value)
            }
        }
    }
}
