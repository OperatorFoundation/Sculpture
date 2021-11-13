//
//  StructureText+Focus.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/13/21.
//

import Foundation
import Focus

extension StructureText
{
    public var line: Line?
    {
        return self.linePrism.tryGet(self)
    }

    public var linePrism: SimplePrism<StructureText, Line>
    {
        SimplePrism<StructureText, Line>(
            tryGet:
                {
                    (text: StructureText) -> Line? in

                    switch text
                    {
                        case .line(let line):
                            return line
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (line: Line) -> StructureText in

                    return .line(line)
                }
        )
    }

    public var list: [StructureText]?
    {
        return self.listPrism.tryGet(self)
    }

    public var listPrism: SimplePrism<StructureText, [StructureText]>
    {
        SimplePrism<StructureText, [StructureText]>(
            tryGet:
                {
                    (text: StructureText) -> [StructureText]? in

                    switch text
                    {
                        case .list(let list):
                            return list
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (list: [StructureText]) -> StructureText in

                    return .list(list)
                }
        )
    }

    public var block: Block?
    {
        return self.blockPrism.tryGet(self)
    }

    public var blockPrism: SimplePrism<StructureText, Block>
    {
        SimplePrism<StructureText, Block>(
            tryGet:
                {
                    (text: StructureText) -> Block? in

                    switch text
                    {
                        case .block(let block):
                            return block
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (block: Block) -> StructureText in

                    return .block(block)
                }
        )
    }
}
