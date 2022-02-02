//
//  StructuralTyping.swift
//
//
//  Created by Dr. Brandon Wiley on 1/25/22.
//

import Foundation
import Gardener
import Abacus

public protocol TypeChecker
{
    init?(focus: Focus<SymbolTree>) throws
    func check(context: Focus<SymbolTree>, value: Focus<SymbolTree>) throws -> Bool
}

public class StructuralTyping
{
    let types: SymbolLexicon

    public init?(typeDirectoryPath: String) throws
    {
        guard let files = File.contentsOfDirectory(atPath: typeDirectoryPath) else {return nil}

        let baseURL = URL(fileURLWithPath: typeDirectoryPath)
        let typesLexicon = SymbolLexicon()

        for file in files
        {
            guard let word = Word(file) else
            {
                continue
            }

            let url = baseURL.appendingPathComponent(file)
            let data = try Data(contentsOf: url)
            let input = data.string

            let parser = try Parser(input)
            print(parser.top)

            let lexicon = try SymbolLexicon(top: parser.top.trees!)
            let symbols = SymbolTree.lexicon(lexicon)
            print(symbols.description)

            let typeLexicon = SymbolLexicon(elements: [(word, .lexicon(lexicon))])
            let tree = SymbolTree.lexicon(typeLexicon)
            guard typesLexicon.set(key: word, value: tree) else {throw StructuralTypingError.failedSet}
        }

        self.types = typesLexicon

        print(SymbolTree.lexicon(self.types).description)
    }

    public func checkType(type: Focus<SymbolTree>, value: Focus<SymbolTree>) throws -> Bool
    {
        guard let literal = try LiteralType(focus: type) else {return false}
        return try literal.check(context: type, value: value)
    }

//    public func check(context: Focus<SymbolTree>, type: LiteralType, value: Focus<SymbolTree>) throws -> Bool
//    {
//        guard let typeCase = StructuralTypes(rawValue: typeName) else {throw StructuralTypingError.unknownStructuralType(typeName)}
//        switch typeCase
//        {
//            case .choice:
//                guard let (maybeValueHead, rest) = type.split, let valueHead = maybeValueHead else
//                {
//                    throw StructuralTypingError.badChoice(.lexicon(value))
//                }
//
//                let choiceString = valueHead.string
//                guard let choiceWord = Word(choiceString) else {return false}
//
//                // Remove head
//                let choiceValue = SymbolLexicon(elements: rest)
//
//                guard let choiceTypeOrName = type.get(key: choiceWord) else {return false}
//                switch choiceTypeOrName
//                {
//                    case .atom(let choiceTypeAtom):
//                        // Named structural type
//                        guard let choiceTypeWord = choiceTypeAtom.word else {throw StructuralTypingError.badChoice(choiceTypeOrName)}
//                        guard let choiceType = getTypeByName(name: choiceTypeWord, localContext: type) else {throw StructuralTypingError.unknownNamedStructuralType(choiceTypeWord.string)}
//                        guard let choiceTypeLexicon = choiceType.lexicon else {throw StructuralTypingError.badChoice(choiceType)}
//                        return try check(type: choiceTypeLexicon, value: choiceValue)
//                    case .lexicon(let choiceTypeLexicon):
//                        // Anonymous structured type
//                        return try check(type: choiceTypeLexicon, value: choiceValue)
//                }
//            case .optional:
//                guard let (maybeValueHead, rest) = type.split, let valueHead = maybeValueHead else
//                {
//                    throw StructuralTypingError.badChoice(.lexicon(value))
//                }
//
//                let valueHeadString = valueHead.string
//
//                guard let typeCase = StructuralTypes(rawValue: valueHeadString) else
//                {
//                    throw StructuralTypingError.unknownStructuralType(valueHeadString)
//                }
//
//                switch typeCase
//                {
//                    case .nothing:
//                        return true
//                    default:
//                        // FIXME
//                        return false
//
//                }
//
//                // Remove head
//                let choiceValue = SymbolLexicon(elements: rest)
//                guard let choiceWord = choiceValue
//
//                guard let choiceTypeOrName = type.get(key: choiceWord) else {return false}
//                switch choiceTypeOrName
//                {
//                    case .atom(let choiceTypeAtom):
//                        // Named structural type
//                        guard let choiceTypeWord = choiceTypeAtom.word else {throw StructuralTypingError.badChoice(choiceTypeOrName)}
//                        guard let choiceType = getTypeByName(name: choiceTypeWord, localContext: type) else {throw StructuralTypingError.unknownNamedStructuralType(choiceTypeWord.string)}
//                        guard let choiceTypeLexicon = choiceType.lexicon else {throw StructuralTypingError.badChoice(choiceType)}
//                        return try check(type: choiceTypeLexicon, value: choiceValue)
//                    case .lexicon(let choiceTypeLexicon):
//                        // Anonymous structured type
//                        return try check(type: choiceTypeLexicon, value: choiceValue)
//                }
//              // FIXME
////            case .sequence:
////            case .structure:
////            case .tuple:
//            default:
//                return false
//        }
//    }

    public func getTypeByName(name: Word, localContext: SymbolLexicon?) -> SymbolTree?
    {
        // FIXME
        return nil

//        var context = self.types
//        if let local = localContext
//        {
//            context = ChainedLexicon(parent: self.types, child: local)
//        }
//
//        guard let choiceTypeValue = localTypeLexicon.get(key: choiceTypeWord) else {throw StructuralTypingError.unknownNamedStructuralType(choiceWord.string)}
//
//        switch choiceTypeValue
//        {
//            case .atom(let choiceValueAtom):
//
//            case .lexicon(let choiceValueLexicon):
//        }
//
//
    }
}

public enum StructuralTypes: String
{
    case basicData = "basic.data"
    case basicFloat = "basic.float"
    case basicInt = "basic.int"
    case choice = "choice"
    case optional = "optional"
    case sequence = "sequence"
    case structure = "structure"
    case tuple = "tuple"
    case nothing = "nothing"
}

public enum StructuralTypingError: Error
{
    case notAType(SymbolLexicon)
    case unknownStructuralType(String)
    case unknownNamedStructuralType(String)
    case failedSet
    case badChoice(SymbolTree)
    case extraneousValues([(Word?, SymbolTree)])
}
