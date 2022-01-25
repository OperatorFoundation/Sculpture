//
//  Eval.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/25/21.
//

import Foundation
import Abacus

extension Program
{
    public func eval(context: Context) -> (Entity?, [Event], [Effect])
    {
        if let input = self.input
        {
            if self.operations.count == 0
            {
                return (input, [], [])
            }

            let result = self.operations.reduce(input)
            {
                (partialResult: Entity?, operation: Operation) -> Entity? in

                switch operation
                {
                    case .function(let clockworkFunction):
                        guard let partialResult = partialResult else {return nil}
                        let (result, _, _) = clockworkFunction.implementation(partialResult)
                        return result
                    default:
                        // FIXME
                        return partialResult
                }
            }

            return (result, [], [])
        }
        else
        {
            guard self.operations.count > 0 else {return (nil, [], [])}

            let first = self.operations[0]
            let rest = [Operation](self.operations[1...])

            switch first
            {
                case .data(let cwdata):
                    let data = self.eval(data: cwdata, context: context)
                    let program = Program(input: data, operations: rest, allowedEvents: [], allowedEffects: [])
                    return program.eval(context: context)
                default:
                    // First operation must be a data constructor
                    return (nil, [], [])
            }
        }
    }

    public func eval(data: ClockworkData, context: Context) -> Entity?
    {
        switch data
        {
            case .atom(let entity):
                return entity
            case .constructor(let f):
                //FIXME
                return nil
            case .expression(let e):
                //FIXME
                return nil
        }
    }

    public func eval(tree: SymbolTree) throws -> (SymbolTree?, [Event], [Effect])
    {
        // FIXME - add builtins
        let builtins = SymbolLexicon()

        // Top-level evaluation has different semantics than in-tree
        switch tree
        {
            case .atom(let atom):
                switch atom
                {
                    case .word(let word):
                        let lexicon = SymbolLexicon(word)
                        var newLexicon = SymbolLexicon()
                        try Lexicon<Word,SymbolTree,Word>.merge(input: builtins, output: &newLexicon)
                        try Lexicon<Word,SymbolTree,Word>.merge(input: lexicon, output: &newLexicon)

                        let (maybeResultLexicon, events, effects) = try self.eval(lexicon: newLexicon)
                        if let resultLexicon = maybeResultLexicon
                        {
                            return (.lexicon(resultLexicon), events, effects)
                        }
                        else
                        {
                            return (nil, events, effects)
                        }
                    default:
                        let newLexicon = SymbolLexicon(nil, elements: [(nil, tree)])
                        let (maybeResultLexicon, events, effects) = try self.eval(lexicon: newLexicon)
                        if let resultLexicon = maybeResultLexicon
                        {
                            return (.lexicon(resultLexicon), events, effects)
                        }
                        else
                        {
                            return (nil, events, effects)
                        }
                }
            case .lexicon(let lexicon):
                var newLexicon = SymbolLexicon()
                try Lexicon<Word,SymbolTree,Word>.merge(input: builtins, output: &newLexicon)
                try Lexicon<Word,SymbolTree,Word>.merge(input: lexicon, output: &newLexicon)

                let (maybeResultLexicon, events, effects) = try self.eval(lexicon: newLexicon)
                if let resultLexicon = maybeResultLexicon
                {
                    return (.lexicon(resultLexicon), events, effects)
                }
                else
                {
                    return (nil, events, effects)
                }
        }
    }

//        if self.operations.count == 0
//            {
//                return (input, [], [])
//            }
//
//            let result = self.operations.reduce(input)
//            {
//                (partialResult: Entity?, operation: Operation) -> Entity? in
//
//                switch operation
//                {
//                    case .function(let clockworkFunction):
//                        guard let partialResult = partialResult else {return nil}
//                        let (result, _, _) = clockworkFunction.implementation(partialResult)
//                        return result
//                    default:
//                        // FIXME
//                        return partialResult
//                }
//            }
//
//            return (result, [], [])
//        }
//        else
//        {
//            guard self.operations.count > 0 else {return (nil, [], [])}
//
//            let first = self.operations[0]
//            let rest = [Operation](self.operations[1...])
//
//            switch first
//            {
//                case .data(let cwdata):
//                    let data = self.eval(data: cwdata, context: context)
//                    let program = Program(input: data, operations: rest, allowedEvents: [], allowedEffects: [])
//                    return program.eval(context: context)
//                default:
//                    // First operation must be a data constructor
//                    return (nil, [], [])
//            }
//        }
//    }

    public func eval(lexicon: SymbolLexicon) throws -> (SymbolLexicon?, [Event], [Effect])
    {
        if let head = lexicon.head
        {
            // Dereference the binding
            guard let value = lexicon.get(key: head) else {throw EvalError.unknownSymbol(head)}

            switch value
            {
                case .atom(let subatom):
                    switch subatom
                    {
                        // Head is word
                        case .word(let word):
                            // New head
                            let elements = lexicon.elements()
                            let result = SymbolLexicon(word, elements: elements)
                            return try self.eval(lexicon: result)
                        // Head is number or data
                        default:
                            // Non-words cannot be head
                            var elements = lexicon.elements()
                            elements.insert((nil, value), at: 0)
                            let result = SymbolLexicon(nil, elements: elements)
                            return try self.eval(lexicon: result)
                    }
                case .lexicon(let sublexicon):
                    // Head is lexicon, could be a function
                    if let call = ClockworkCall(sublexicon)
                    {
                        // Head is a function

                    }
                    else
                    {
                        // Head is not a function
                        // Non-words cannot be head
                        var elements = lexicon.elements()
                        elements.insert((nil, value), at: 0)
                        let result = SymbolLexicon(nil, elements: elements)
                        return try self.eval(lexicon: result)
                    }
            }
        }

        for (maybeKey, value) in lexicon.elements()
        {
            // Skip evaluating bindings
            guard maybeKey == nil else {continue}
        }

        return (nil, [], [])
    }
}

public enum EvalError: Error
{
    case unknownSymbol(Word)
}
