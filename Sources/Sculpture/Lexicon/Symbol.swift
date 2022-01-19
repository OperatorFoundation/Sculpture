//
//  Symbol.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/14/22.
//

import Foundation

public enum Symbol: Codable, Equatable, Hashable
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

public struct Number: Equatable
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
}

public struct Word: Codable, Hashable, Equatable
{
    public let string: String

    public init?(_ string: String)
    {
        // Can't start with a digit
        let regexp = #"^[A-Za-z]\w*$"#
        guard string.range(of: regexp, options: .regularExpression) != nil else
        {
            return nil
        }

        self.string = string
    }
}

public struct Index: Codable, Equatable, Hashable
{
    public let string: String

    public var int: Int?
    {
        return Int(string: self.string)
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
