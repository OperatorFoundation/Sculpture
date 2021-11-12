//
//  File.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/11/21.
//

import Foundation
import CloudKit
import AST

typealias Chunk = [(Int, String)]

extension StructureText: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        let lines = description.split(separator: "\n")
        let indented: Chunk = lines.map
        {
            substring in

            let string = String(substring)
            var indent = 0
            var index = string.startIndex
            while string[index] == "\t"
            {
                indent += 1
                index = string.index(after: index)
            }

            let line = String(string[index...])
            return (indent, line)
        }

        self.init(chunk: indented)
    }

    init?(chunk indented: Chunk)
    {
        var lowestIndexes: [Int] = []
        var index = 0
        for (indent, line) in indented
        {
            let trimmed = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmed.count > 0
            {
                // Non-blank line
                if lowestIndexes.isEmpty
                {
                    lowestIndexes.append(index)
                }
                else
                {
                    if indent < indented[lowestIndexes[0]].0
                    {
                        // Syntax error
                        return nil
                    }
                    else if indent == indented[lowestIndexes[0]].0
                    {
                        lowestIndexes.append(index)
                    }
                }
            }

            index += 1
        }

        if lowestIndexes.isEmpty
        {
            // Empty
            return nil
        }
        else if lowestIndexes.count == 1
        {
            // Line or Block
            let index = lowestIndexes[0]
            let (chunkIndent, chunkString) = indented[index]
            let innerLines = Chunk(indented[index...]).filter
            {
                (indent, line) in

                return indent > chunkIndent
            }

            if innerLines.isEmpty
            {
                // Line
                let trimmed = chunkString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let parts = trimmed.split(separator: " ", omittingEmptySubsequences: true)
                let name = String(parts[0])
                let parameters = parts[1...].map { String($0) }
                let line = Line(name: name, parameters: parameters)
                self = .line(line)
            }
            else
            {
                // Block
                let trimmed = chunkString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let parts = trimmed.split(separator: " ", omittingEmptySubsequences: true)
                let name = String(parts[0])
                let parameters = parts[1...].map { String($0) }
                let line = Line(name: name, parameters: parameters)

                guard let subtext = StructureText(chunk: innerLines) else {return nil}
                self = .block(Block(line: line, inner: subtext))
            }
        }
        else
        {
            // List
            var texts: [StructureText] = []
            for (metaindex, index) in lowestIndexes.enumerated()
            {
                if metaindex == lowestIndexes.count - 1
                {
                    // Last inded
                    let block: Chunk = Chunk(indented[index...])
                    guard let text = StructureText(chunk: block) else {return nil}
                    texts.append(text)
                }
                else
                {
                    // Not last index
                    let nextIndex = lowestIndexes[metaindex + 1]
                    let block = Chunk(indented[index..<nextIndex])
                    guard let text = StructureText(chunk: block) else {return nil}
                    texts.append(text)
                }
            }

            self = .list(texts)
        }
    }

    public var description: String
    {
        return toStringWithIndentation(indent: 0)
    }

    func toStringWithIndentation(indent: Int) -> String
    {
        let indentation = String(repeating: "\t", count: indent)

        switch self
        {
            case .line(let line):
                let parameters = line.parameters.joined(separator: " ")
                return "\(indentation)\(line.name) \(parameters)\n"

            case .block(let block):
                let line: StructureText = .line(block.line)
                let lineString = line.toStringWithIndentation(indent: indent)
                let blockString = block.inner.toStringWithIndentation(indent: indent + 1)

                return lineString + blockString

            case .list(let list):
                let listStrings: [String] = list.map
                {
                    item in

                    return item.toStringWithIndentation(indent: indent + 1)
                }
                let listString = listStrings.joined(separator: "")
                return listString
        }
    }
}
