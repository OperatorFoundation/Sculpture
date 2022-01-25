//
//  SymbolLexicon+Datable.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/22/22.
//

import Foundation
import Datable

//extension SymbolLexicon: MaybeDatable
//{
//    public var data: Data
//    {
//        return self.dataWithDepth(depth: 0)
//    }
//
//    public func dataWithDepth(depth: UInt8) -> Data
//    {
//        var data = Data()
//        let depthData = depth.data
//
//        for (maybeWord, value) in self.elements()
//        {
//            if let word = maybeWord
//            {
//                data.append(depthData)
//
//                let wordData = word.data
//                data.append(wordData)
//
//                let valueData = value.dataWithDepth(depth: depth + 1)
//                data.append(valueData)
//            }
//            else
//            {
//                data.append(depthData)
//
//                let zero: UInt8 = 0
//                let zeroData = zero.data
//                data.append(zeroData)
//
//                let valueData = value.dataWithDepth(depth: depth + 1)
//                data.append(valueData)
//            }
//        }
//
//        return data
//    }
//
//    public convenience init?(data: Data)
//    {
//        guard data.count > 2 else {return nil}
//
//        let depthData = Data(data[0..<1])
//        let depth8 = depthData.uint8
//        let depth = Int(depth8)
//
//        
//
//        guard let wordUint8 = first.uint8 else {return nil}
//        let wordCount = Int(wordUint8)
//
//        if wordCount > 0
//        {
//            guard data.count >= wordCount + 1 else {return nil}
//            let wordData = Data(data[0..<wordCount+1])
//            guard let word = Word(data: wordData) else {return nil}
//
//            let rest = Data(data[wordCount+1...])
//
//        }
//        else
//        {
//        }
//    }
//}

//extension SymbolTree: MaybeDatable
//{
//    public var data: Data?
//    {
//
//    }
//
//    public init?(data: Data)
//    {
//
//    }
//}
