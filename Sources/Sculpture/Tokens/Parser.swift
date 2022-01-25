//
//  Parser.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/11/22.
//

import Foundation
import Focus
import Abacus

public class Parser
{
    public var string: String
    public var top: ParserTree

    public init(_ string: String) throws
    {
        self.string = string
        self.top = try Parser.parseTree(string)
    }

    public init(_ tree: ParserTree) throws
    {
        self.top = tree
        self.string = Parser.flattenTree(tree)
    }

    static func parseTree(_ string: String) throws -> ParserTree
    {
        let lines = string.split(separator: "\n")

        // This creates a list of tokenizes lines, with associated depth.
        // Each line is a list.
        var lineTrees: [(Int, ParserTree)] = []
        for line in lines
        {
            let string = String(line)
            let text = string.drop
            {
                (char: Character) -> Bool in

                char == "\t"
            }

            let depth = string.count - text.count

            let textString = String(text)

            let tokenizer = try Tokenizer(string: textString+"\n")
            let lineTokens = tokenizer.tokens
            var lineResults: [ParserTree] = []
            for token in lineTokens
            {
                lineResults.append(ParserTree.token(token))
            }

            // Each line starts out as a list of tokens
            lineTrees.append((depth, ParserTree.trees(lineResults)))
        }

        // All that is left is to make the nested lines into sublists of their parent lines
        // tempLists is a mapping fro depth (index) to line
        var workingTree: ParserTree = .trees([])
        var lastDepth = 0
        for (index, lineTreeWithDepth) in lineTrees.enumerated()
        {
            print(workingTree.description)
            let (depth, lineTree) = lineTreeWithDepth

            if depth == 0
            {
                // Append to top list

                var trees = workingTree.trees!
                trees.append(lineTree)
                workingTree = .trees(trees)
            }
            else if depth <= lastDepth || depth == (lastDepth + 1)
            {
                var focus = try Focus<ParserTree>(tree: workingTree)
                for _ in 0..<depth
                {
                    let tempIndex = try focus.count() - 1
                    focus = try focus.narrow(tempIndex)
                }

                // Merge new line at the right depth in the tree
                let target = try focus.get()
                var targetTrees = target.trees!
                targetTrees.append(lineTree)
                focus = try focus.set(.trees(targetTrees))
                workingTree = focus.tree
            }
            else
            {
                throw ParserError.badDepthTooDeep(index, lastDepth + 1, depth)
            }

            lastDepth = depth
        }

        return workingTree
    }

    static func flattenTree(_ tree: ParserTree) -> String
    {
        var result: String = ""

        let trees = tree.trees!
        for topTree in trees
        {
            let lines = Parser.flattenTrees(topTree.trees!, 0)

            for line in lines
            {
                let (depth, tokens) = line

                for _ in 0..<depth
                {
                    result.append("\t")
                }

                for token in tokens
                {
                    result.append(token.string!)
                    result.append(" ")
                }

                if !result.isEmpty
                {
                    var end = result.index(before: result.endIndex)
                    if result[end] == " "
                    {
                        let end = result.index(before: result.endIndex)
                        result = String(result[result.startIndex..<end])
                    }

                    end = result.index(before: result.endIndex)
                    if result[end] != "\n"
                    {
                        result.append("\n")
                    }
                }
            }
        }

        return result
    }

    typealias Line = (Int, [Token])

    static func flattenTrees(_ trees: [ParserTree], _ depth: Int) -> [Line]
    {
        var lines: [Line] = []

        var topline: Line? = nil
        var tokens: [Token] = []
        for tree in trees
        {
            if topline == nil
            {
                switch tree
                {
                    case .token(let token):
                        tokens.append(token)
                    case .trees(let subtrees):
                        topline = (depth, tokens)
                        lines.append(topline!)
                        let sublines = Parser.flattenTrees(subtrees, depth + 1)
                        lines.append(contentsOf: sublines)
                }
            }
            else
            {
                let sublines = Parser.flattenTrees(tree.trees!, depth + 1)
                lines.append(contentsOf: sublines)
            }
        }

        if topline == nil
        {
            topline = (depth, tokens)
            lines.append(topline!)
        }

        return lines
    }
}

public indirect enum ParserTree: CustomStringConvertible
{
    case token(Token)
    case trees([ParserTree])

    public var description: String
    {
        var result = ""
        switch self
        {
            case .token(let token):
                guard let string = token.string else {return "<error>"}
                result.append(string)
                result.append(" ")
            case .trees(let trees):
                result.append("(")
                for tree in trees
                {
                    result.append(tree.description)
                }

                let end = result.index(before: result.endIndex)
                if result[end] == " "
                {
                    result = String(result[result.startIndex..<end])
                }
                result.append(") ")
        }

        return result
    }

    public var token: Token?
    {
        switch self
        {
            case .token(let token):
                return token
            default:
                return nil
        }
    }

    public var trees: [ParserTree]?
    {
        switch self
        {
            case .trees(let trees):
                return trees
            default:
                return nil
        }
    }

    public func append(_ tree: ParserTree) -> ParserTree
    {
        switch self
        {
            case .token(_):
                return ParserTree.trees([self, tree])
            case .trees(let trees):
                return ParserTree.trees(trees + [tree])
        }
    }
}

public enum ParserError: Error
{
    case emptyTokens
    case badHeight(Int, Token, Int, Int) // index, token, expected height, actual height
    case badDepthTooShallow(Int, Token, Int, Int) // index, token, expected depth, actual depth
    case badDepthTooDeep(Int, Int, Int) // index, expected depth, actual depth
}
