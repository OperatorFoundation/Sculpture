//
//  Types+TypeChecker.swift
//
//
//  Created by Dr. Brandon Wiley on 1/26/22.
//

import Foundation

extension LiteralType: TypeChecker
{
    // Create a structural type using a SymbolTree to provide the details.
    public init?(focus: Focus<SymbolTree>) throws
    {
        let tree = try focus.get()

        switch tree
        {
            case .atom(let atom):
                switch atom
                {
                    case .word(let word):
                        // If the type is just a single word, then it must be a basic type.
                        let typeCase = StructuralTypes(rawValue: word.string)
                        switch typeCase
                        {
                            case .basicData:
                                self = .basic(.bytes)
                                return
                            case .basicFloat:
                                self = .basic(.float)
                                return
                            case .basicInt:
                                self = .basic(.int)
                                return
                            default:
                                return nil
                        }
                    default:
                        return nil
                }
            case .lexicon(let lexicon):
                try self.init(context: focus, lexicon: lexicon)
        }
    }

    public init?(context: Focus<SymbolTree>, lexicon: SymbolLexicon) throws
    {
        guard let (maybeValue, rest) = lexicon.split else {throw StructuralTypingError.notAType(lexicon)}
        guard let value = maybeValue else {throw StructuralTypingError.notAType(lexicon)}
        guard let atom = value.atom else {throw StructuralTypingError.notAType(lexicon)}
        guard let typeHead = atom.word else {throw StructuralTypingError.notAType(lexicon)}

        let typeName = typeHead.string
        guard let typeCase = StructuralTypes(rawValue: typeName) else {throw StructuralTypingError.unknownStructuralType(typeName)}
        switch typeCase
        {
            case .basicInt:
                guard let basic = try BasicType(focus: context) else
                {
                    return nil
                }
                self = .basic(basic)
                return
            case .basicFloat:
                guard let basic = try BasicType(focus: context) else {return nil}
                self = .basic(basic)
                return
            case .basicData:
                guard let basic = try BasicType(focus: context) else
                {
                    return nil
                }
                self = .basic(basic)
                return
            case .structure:
                let newTree = SymbolTree.lexicon(SymbolLexicon(elements: rest))
                let newFocus = try Focus<SymbolTree>(tree: newTree)
                guard let structure = try Structure(focus: newFocus) else
                {
                    return nil
                }
                self = .structure(structure)
                return
            case .sequence:
                let newTree = SymbolTree.lexicon(SymbolLexicon(elements: rest))
                let newFocus = try Focus<SymbolTree>(tree: newTree)
                guard let sequence = try Sequence(focus: newFocus) else
                {
                    return nil
                }
                self = .sequence(sequence)
                return
            case .choice:
                let newTree = SymbolTree.lexicon(SymbolLexicon(elements: rest))
                let newFocus = try Focus<SymbolTree>(tree: newTree)
                guard let choice = try Choice(focus: newFocus) else
                {
                    return nil
                }
                self = .choice(choice)
                return
            default:
                // FIXME: Other types are not yet supported.
                return nil
        }

        return nil
    }

    public func check(context: Focus<SymbolTree>, value: Focus<SymbolTree>) throws -> Bool
    {
        switch self
        {
            case .basic(let basic):
                return try basic.check(context: context, value: value)
            case .structure(let structure):
                return try structure.check(context: context, value: value)
            case .sequence(let sequence):
                return try sequence.check(context: context, value: value)
            case .choice(let choice):
                return try choice.check(context: context, value: value)
            default:
                throw StructuralTypingError.unknownStructuralType(self.description)
        }
    }
}

extension BasicType: TypeChecker
{
    public init?(focus: Focus<SymbolTree>) throws
    {
        let tree = try focus.get()

        switch tree
        {
            case .atom(let atom):
                switch atom
                {
                    case .word(let word):
                        // If the type is just a single word, then it must be a basic type.
                        let typeCase = StructuralTypes(rawValue: word.string)
                        switch typeCase
                        {
                            case .basicData:
                                self = .bytes
                                return
                            case .basicFloat:
                                self = .float
                                return
                            case .basicInt:
                                self = .int
                                return
                            default:
                                return nil
                        }
                    default:
                        return nil
                }
            case .lexicon(_):
                let newFocus = try focus.narrow(Symbol.index(Index(0)!))
                try self.init(focus: newFocus)
        }
    }

    public func check(context: Focus<SymbolTree>, value: Focus<SymbolTree>) throws -> Bool
    {
        let tree = try value.get()

        switch tree
        {
            case .atom(let atom):
                switch atom
                {
                    case .word(let word):
                        if let resolved = try? resolve(context: context, symbol: word)
                        {
                            return try self.check(context: context, value: resolved)
                        }
                        else
                        {
                            switch self
                            {
                                case .bytes:
                                    return try Data(context: context, value: value) != nil
                                default:
                                    return false
                            }
                        }
                    case .number(_):
                        switch self
                        {
                            case .bytes:
                                return try Data(context: context, value: value) != nil
                            case .float:
                                return try Float64(context: context, value: value) != nil
                            case .int:
                                return try Int64(context: context, value: value) != nil
                            default:
                                return false
                        }
                    case .data(_):
                        switch self
                        {
                            case .bytes:
                                return try Data(context: context, value: value) != nil
                            case .float:
                                return try Float64(context: context, value: value) != nil
                            case .int:
                                return try Int64(context: context, value: value) != nil
                            default:
                                return false
                        }
                }
            case .lexicon(_):
                return false
        }
    }
}

extension Choice: TypeChecker
{
    public init?(focus: Focus<SymbolTree>) throws
    {
        let tree = try focus.get()

        switch tree
        {
            case .atom(_):
                return nil
            case .lexicon(let lexicon):
                let options = try lexicon.values().enumerated().map
                {
                    (int: Int, _) throws -> Option in

                    guard let index = Index(int) else {throw SymbolicError.badSymbol(Token(start: TokenPosition(), string: int.string))}
                    let newFocus = try focus.narrow(.index(index))
                    guard let option = try Option(focus: newFocus) else {throw SymbolicError.badSymbol(Token(start: TokenPosition(), string: int.string))}
                    return option
                }

                self.init("", options)
        }
    }

    public func check(context: Focus<SymbolTree>, value: Focus<SymbolTree>) throws -> Bool
    {
        let tree = try value.get()

        switch tree
        {
            case .atom(_):
                for choiceOption in self.options
                {
                    if try choiceOption.check(context: context, value: value)
                    {
                        return true
                    }
                }

                return false
            case .lexicon(_):
                let index = Symbol.index(Index(0))
                let newFocus = try value.narrow(index)
                for choiceOption in self.options
                {
                    if try choiceOption.check(context: context, value: newFocus)
                    {
                        return true
                    }
                }

                return false
        }
    }
}

extension Option: TypeChecker
{
    public init?(focus: Focus<SymbolTree>) throws
    {
        self.name = ""

        let tree = try focus.get()

        guard let type = try LiteralType(focus: focus) else
        {
            throw StructuralTypingError.badChoice(tree)
        }
        self.types = [.literal(type)]
    }

    public func check(context: Focus<SymbolTree>, value: Focus<SymbolTree>) throws -> Bool
    {
        guard self.types.count == 1 else {throw StructuralTypingError.unknownNamedStructuralType("too many types in Option")}
        let type = self.types[0]
        switch type
        {
            case .literal(let literal):
                return try literal.check(context: context, value: value)
            default:
                throw StructuralTypingError.unknownStructuralType(type.description)
        }
    }
}

extension Sequence: TypeChecker
{
    public init?(focus: Focus<SymbolTree>) throws
    {
        let tree = try focus.get()

        guard let type = try LiteralType(focus: focus) else
        {
            throw StructuralTypingError.badChoice(tree)
        }
        self.type = .literal(type)
    }

    public func check(context: Focus<SymbolTree>, value: Focus<SymbolTree>) throws -> Bool
    {
        let tree = try value.get()

        switch self.type
        {
            case .literal(let literal):
                switch tree
                {
                    case .atom(_):
                        return false
                    case .lexicon(let lexicon):
                        for (int, _) in lexicon.values().enumerated()
                        {
                            let index = Symbol.index(Index(int)!)
                            let newFocus = try value.narrow(index)
                            guard try literal.check(context: context, value: newFocus) else {return false}
                        }

                        return true
                }
            default:
                throw StructuralTypingError.unknownStructuralType(self.type.description)
        }
    }
}

extension Structure: TypeChecker
{
    public init?(focus: Focus<SymbolTree>) throws
    {
        self.name = ""

        let tree = try focus.get()

        switch tree
        {
            case .atom(_):
                return nil
            case .lexicon(let lexicon):
                let properties = try lexicon.values().enumerated().map
                {
                    (int, _) throws -> Property in

                    let index = Symbol.index(Index(int)!)
                    let newFocus = try focus.narrow(index)
                    guard let type = try LiteralType(focus: newFocus) else
                    {
                        throw StructuralTypingError.badChoice(tree)
                    }
                    return Property("", type: .literal(type))
                }

                self.properties = properties
        }
    }

    public func check(context: Focus<SymbolTree>, value: Focus<SymbolTree>) throws -> Bool
    {
        let tree = try value.get()

        let types = try self.properties.map
        {
            (property: Property) throws -> LiteralType in

            switch property.type
            {
                case .literal(let literal):
                    return literal
                default:
                    throw StructuralTypingError.badChoice(tree)
            }
        }

        for (int, literal) in types.enumerated()
        {
            let index = Symbol.index(Index(int)!)
            let newFocus = try value.narrow(index)
            guard try literal.check(context: context, value: newFocus) else {return false}
        }

        return true
    }
}
