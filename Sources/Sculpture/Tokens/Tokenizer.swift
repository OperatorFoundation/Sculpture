//
//  Tokenizer.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/10/22.
//

import Foundation
import Gardener

public class Tokenizer
{
    let path: String
    let contents: Data
    let tokens: [Token]

    public init(path: String) throws
    {
        self.path = path
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        self.contents = data

        let tokens = try Tokenizer.tokenize(self.contents)
        self.tokens = tokens
    }

    public init(string: String) throws
    {
        self.path = "string"
        let data = string.data
        self.contents = data

        let tokens = try Tokenizer.tokenize(self.contents)
        self.tokens = tokens
    }

    static func tokenize(_ data: Data) throws -> [Token]
    {
        var tokens: [Token] = []
        var position = TokenPosition()
        var token = Token(start: position)

        for byte in data
        {
            // This is silly.
            let char = Data(array: [byte]).string

            let alphanumeric = #"[A-Za-z0-9_:\-\\.,]"#

            if char.range(of: alphanumeric, options: .regularExpression) != nil
            {
                token.append(char)
                position.index += 1
                position.width += 1
            }
            else
            {
                switch char
                {
                    case " ":
                        guard !token.isEmpty else
                        {
                            throw TokenizerError.badSpace(position)
                        }

                        try token.finalize()
                        try checkBinding(token, tokens)

                        tokens.append(token)

                        position.index += 1
                        position.width += 1

                        token = Token(start: position)
                    case "\n":
                        // New line
                        if !token.isEmpty
                        {
                            try token.finalize()
                            try checkBinding(token, tokens)
                            tokens.append(token)
                        }

                        position.index += 1
                        position.height += 1
                        position.width = 0
                        position.depth = 0

                        token = Token(start: position)
                    case "\t":
                        if let lastToken = tokens.last
                        {
                            guard lastToken.range.start.height < position.height else
                            {
                                throw TokenizerError.badTab(position)
                            }
                        }

                        position.index += 1
                        position.depth += 1

                        token = Token(start: position)
                    default:
                        throw TokenizerError.invalidCharacter(position, char)
                }
            }
        }

        guard token.isEmpty else {throw TokenizerError.noTrailingNewline}

        return tokens
    }

    static func checkBinding(_ token: Token, _ tokens: [Token]) throws
    {
        guard let type = token.type else
        {
            throw TokenizerError.tokenHasNoType(token.range.start)
        }

        if type.bindingSymbol != nil
        {
            if let last = tokens.last
            {
                if last.range.start.height == token.range.start.height
                {
                    throw TokenizerError.invalidPositionForBinding(token.range.start)
                }
            }
        }

    }
}

public class Formatter
{
    static public func format(tokens: [Token]) -> String
    {
        if tokens.count == 0
        {
            return ""
        }
        else if tokens.count == 1
        {
            var result = ""

            let token = tokens[0]
            guard let string = token.string else
            {
                return ""
            }

            for _ in 0..<token.range.start.depth
            {
                result.append("\t")
            }

            result.append(string)
            result.append("\n")
            return result
        }
        else
        {
            var result = ""
            var index = 0
            let lastIndex = tokens.count - 1
            var previousHeight = 0

            while index <= lastIndex
            {
                let token = tokens[index]
                guard let string = token.string else {return ""}

                if index == 0
                {
                    // First element, begins a new line
                    for _ in 0..<token.range.start.depth
                    {
                        result.append("\t")
                    }

                    result.append(string)
                }
                else if index == lastIndex
                {
                    // Last element
                    if token.range.start.height > previousHeight
                    {
                        // New line
                        result.append("\n")
                        for _ in 0..<token.range.start.depth
                        {
                            result.append("\t")
                        }

                        result.append(string)
                        result.append("\n")
                    }
                    else
                    {
                        // Same line
                        result.append(" ")
                        result.append(string)
                        result.append("\n")
                    }
                }
                else
                {
                    // Middle element
                    if token.range.start.height > previousHeight
                    {
                        // New line
                        result.append("\n")
                        for _ in 0..<token.range.start.depth
                        {
                            result.append("\t")
                        }

                        result.append(string)
                    }
                    else
                    {
                        // Same line
                        result.append(" ")
                        result.append(string)
                    }
                }

                index += 1
                previousHeight = token.range.start.height
            }

            return result
        }
    }
}

public struct TokenPosition: Equatable
{
    public var height: Int
    public var width: Int
    public var depth: Int
    public var index: Int

    public init()
    {
        self.height = 0
        self.width = 0
        self.depth = 0
        self.index = 0
    }
}

public struct TokenRange: Equatable
{
    public var start: TokenPosition
    public var end: TokenPosition
}

public struct Token: Equatable
{
    public var isEmpty: Bool
    {
        return self.count == 0
    }

    public var count: Int
    {
        return self.data.count
    }

    var range: TokenRange
    var data: Data = Data()
    var string: String? = nil
    var type: LexicalType? = nil

    public init(start: TokenPosition)
    {
        self.range = TokenRange(start: start, end: start)
    }

    public init(start: TokenPosition, string: String)
    {
        self.string = string
        self.data = string.data
        var end = TokenPosition()
        end.depth = start.depth
        end.index = start.index
        end.width = start.width + string.count
        end.height = start.height
        self.range = TokenRange(start: start, end: end)
    }

    public init(start: TokenPosition, string: String, type: LexicalType)
    {
        self.string = string
        self.type = type
        self.data = string.data
        var end = start
        end.index += self.data.count

        self.range = TokenRange(start: start, end: end)
    }

    public mutating func append(_ string: String)
    {
        self.data.append(string.data)
        self.range.end.index += 1
        self.range.end.width += 1
    }

    public mutating func finalize() throws
    {
        self.string = self.data.string
        self.type = try LexicalTyping.inferType(self)
    }
}

public enum TokenizerError: Error
{
    case tokenHasNoType(TokenPosition)
    case fileNotFound(String)
    case invalidCharacter(TokenPosition, String)
    case badSpace(TokenPosition)
    case badTab(TokenPosition)
    case noTrailingNewline
    case invalidPositionForBinding(TokenPosition)
}
