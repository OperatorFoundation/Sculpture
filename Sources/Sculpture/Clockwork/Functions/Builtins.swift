//
//  Builtins.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/22/22.
//

import Foundation

public class Builtins
{
    var builtins: [Word: ClockworkFunction] =
    [
        Word("builtins.incr")!: incr
    ]

    public func getBuiltins() -> SymbolLexicon
    {
        let result = SymbolLexicon()

        for key in builtins.keys
        {
            let function = self.builtins[key]!
            let word = Word(function.name)!
            let value = SymbolTree.atom(.word(word))

            let _ = result.set(key: key, value: value)
        }

        return result
    }

    public func getBuiltinByName(_ name: Word) -> ClockworkFunction?
    {
        return self.builtins[name]
    }
}
