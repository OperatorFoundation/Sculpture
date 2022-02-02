//
//  Types+Lexicon.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/30/22.
//

import Foundation

extension Data
{
    public init?(context: Focus<SymbolTree>, value: Focus<SymbolTree>) throws
    {
        let tree = try value.get()

        switch tree
        {
            case .atom(let atom):
                switch atom
                {
                    case .data(let data):
                        self = data
                    case .number(let number):
                        if let int64 = Int64(number.string)
                        {
                            let uint64 = UInt64(bitPattern: int64)
                            guard let data = uint64.maybeNetworkData else {return nil}
                            self = data
                        }
                        else if let float64 = Float64(number.string)
                        {
                            let data = float64.data
                            self = data
                        }
                        else
                        {
                            return nil
                        }
                    case .word(let word):
                        guard let value = try resolve(context: context, symbol: word) else {return nil}
                        try self.init(context: context, value: value)
                }
            case .lexicon(_):
                return nil
        }
    }
}

extension Int64
{
    public init?(context: Focus<SymbolTree>, value: Focus<SymbolTree>) throws
    {
        let tree = try value.get()

        switch tree
        {
            case .atom(let atom):
                switch atom
                {
                    case .data(let data):
                        let uint64 = UInt64(data: data)
                        let int64 = Int64(bitPattern: uint64)
                        self = int64
                    case .number(let number):
                        guard let int64 = Int64(number.string) else {return nil}
                        self = int64
                    case .word(let word):
                        guard let value = try resolve(context: context, symbol: word) else {return nil}
                        try self.init(context: context, value: value)
                }
            case .lexicon(_):
                return nil
        }
    }
}

extension Float64
{
    public init?(context: Focus<SymbolTree>, value: Focus<SymbolTree>) throws
    {
        let tree = try value.get()

        switch tree
        {
            case .atom(let atom):
                switch atom
                {
                    case .data(let data):
                        guard let float64 = Float64(data: data) else {return nil}
                        self = float64
                    case .number(let number):
                        guard let float64 = Float64(number.string) else {return nil}
                        self = float64
                    case .word(let word):
                        guard let value = try resolve(context: context, symbol: word) else {return nil}
                        try self.init(context: context, value: value)
                }
            case .lexicon(_):
                return nil
        }
    }
}
