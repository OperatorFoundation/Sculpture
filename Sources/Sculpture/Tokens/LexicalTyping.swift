//
//  LexicalTyping.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/13/22.
//

import Foundation

public struct LexicalTyping
{
    static func inferType(_ token: Token) throws -> LexicalType
    {
        return try LexicalType(token)
    }
}

public enum LexicalType: Equatable
{
    case bindingSymbol(Word)
    case atomicValue(AtomicValue)

    public var bindingSymbol: Word?
    {
        switch self
        {
            case .bindingSymbol(let symbol):
                return symbol
            default: return nil
        }
    }

    public var atomicValue: AtomicValue?
    {
        switch self
        {
            case .atomicValue(let value):
                return value
            default:
                return nil
        }
    }

    public init(_ token: Token) throws
    {
        guard let string = token.string else {throw LexicalError.emptyToken}
        let regexp = #"^[A-Za-z][A-Za-z0-9\\._]*:$"#
        if string.range(of: regexp, options: .regularExpression) != nil
        {
            let start = string.startIndex
            let end = string.index(before: string.endIndex)
            // Remove trailing :
            let substring = String(string[start..<end])
            if let symbol = Word(substring)
            {
                self = .bindingSymbol(symbol)
                return
            }
            else
            {
                throw LexicalError.badLexicalType(token)
            }
        }
        else if let value = AtomicValue(string)
        {
            self = .atomicValue(value)
            return
        }
        else
        {
            throw LexicalError.badLexicalType(token)
        }
    }
}

public enum LexicalError: Error
{
    case emptyToken
    case badLexicalType(Token)
}
