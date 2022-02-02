import XCTest
@testable import Sculpture
import Backtrace
import Gardener

final class SculptureTests: XCTestCase {
    public override func setUp()
    {
        Backtrace.install()
    }

    func testExample() throws
    {
    }

    // Type tests
    func testEntityType()
    {
        let correct = Entity.type(.literal(.basic(.string)))

        let data = correct.data
        let maybeResult = Entity(data: data)

        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = Entity(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    func testType()
    {
        let correct = Type.literal(.basic(.string))

        let data = correct.data
        let maybeResult = Type(data: data)

        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = Type(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)

    }

    func testBasicTypeString()
    {
        let correct = BasicType.string

        let data = correct.data
        let maybeResult = BasicType(data: data)

        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
    }

    func testBasicTypeInt()
    {
        let correct = BasicType.int

        let data = correct.data
        let maybeResult = BasicType(data: data)

        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
    }

    func testBasicTypeUint()
    {
        let correct = BasicType.uint

        let data = correct.data
        let maybeResult = BasicType(data: data)

        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
    }

    func testOption()
    {
        let correct = Option("TestOption", [])

        let data = correct.data
        let maybeResult = Option(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)
    }

    func testChoice()
    {
//        let correct = OptionValue("TestChoice", "TestOption", [])
        let correct: Choice = Choice("TestChoice", [Option("TestOption", [])])

        let data = correct.data
        let maybeResult = Choice(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = Choice(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    func testSequence()
    {
        let correct = Sequence(Type.literal(.choice(Choice("TestChoice", []))))

        let data = correct.data
        let maybeResult = Sequence(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = Sequence(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    func testPropertyBasicString()
    {
        let correct = Property("name", type: Type.literal(.basic(.string)))

        let data = correct.data
        let maybeResult = Property(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = Property(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    func testStructure()
    {
        let correct = Structure("Test",
            [
                Property("name", type: Type.literal(.basic(.string)))
            ]
        )

        let data = correct.data
        let maybeResult = Structure(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = Structure(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    // Value tests
    func testBasicValueString()
    {
        let correct = "test"

        let basic = BasicValue.string(correct)
        let data = basic.data
        let maybeResult = BasicValue(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        switch result
        {
            case .string(let value):
                XCTAssertEqual(value, correct)
            default:
                XCTFail()
        }
    }

    func testBasicValueUInt()
    {
        let correct: UInt64 = 128

        let basic = BasicValue.uint(correct)
        let data = basic.data
        let maybeResult = BasicValue(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        switch result
        {
            case .uint(let value):
                XCTAssertEqual(value, correct)
            default:
                XCTFail()
        }
    }

    func testOptionValue()
    {
        let correct = OptionValue("TestChoice", "TestOption", [])

        let data = correct.data
        let maybeResult = OptionValue(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = OptionValue(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    func testSequenceValue()
    {
        let correct = SequenceValue("String", [])

        let data = correct.data
        let maybeResult = SequenceValue(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = SequenceValue(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    func testSequenceValueString()
    {
        let correct = SequenceValue("String", [.literal(.basic(.string("test")))])

        let data = correct.data
        let maybeResult = SequenceValue(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = SequenceValue(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    func testPropertyValueBasicString()
    {
        let correct = Value.literal(.basic(BasicValue.string("test")))

        let data = correct.data
        let maybeResult = Value(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = Value(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    func testStructureInstance()
    {
        let correct = StructureInstance("Test", values: [Value.literal(.basic(.string("test")))])

        let data = correct.data
        let maybeResult = StructureInstance(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = StructureInstance(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    func testValue()
    {
        let correct = Value.literal(.basic(.string("test")))

        let data = correct.data
        let maybeResult = Value(data: data)

        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = Value(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    func testEntityValue()
    {
        let correct = Entity.value(.literal(.basic(.string("test"))))

        let data = correct.data
        let maybeResult = Entity(data: data)

        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}
        XCTAssertEqual(result, correct)

        let string = correct.description
        print(string)
        let maybeStringResult = Entity(string)
        XCTAssertNotNil(maybeStringResult)
        guard let stringResult = maybeStringResult else {return}
        XCTAssertEqual(stringResult, correct)
    }

    public func testClockwork()
    {
        let context = Context()
        context.put("zero", .data(.atom(.value(.literal(.basic(.int(0)))))))

        let clockwork = Clockwork()
        guard let program = clockwork.parse(string: "zero", context: context) else
        {
            XCTFail()
            return
        }

        print(program)

        let (maybeResult, _, _) = program.eval(context: context)
        guard let result = maybeResult else
        {
            XCTFail()
            return
        }

        print(result)
    }

    public func testClockwork_incr()
    {
        let context = Context()
        context.put("zero", .data(.atom(.value(.literal(.basic(.int(0)))))))
        context.put("incr", .function(incr))

        let clockwork = Clockwork()
        guard let program = clockwork.parse(string: "zero incr", context: context) else
        {
            XCTFail()
            return
        }

        print(program)

        let (maybeResult, _, _) = program.eval(context: context)
        guard let result = maybeResult else
        {
            XCTFail()
            return
        }

        print(result)
    }

    public func testLexiconWord()
    {
        guard let word = Word("test") else
        {
            XCTFail()
            return
        }

        let tree = SymbolTree.atom(AtomicValue.word(word))
        guard let particle = tree.particle else
        {
            XCTFail()
            return
        }
        let text = particle.structureText
        print(text)

        guard let p2 = text.particle else
        {
            XCTFail()
            return
        }

        guard let t2 = SymbolTree(particle: p2) else
        {
            XCTFail()
            return
        }

        guard t2 == tree else
        {
            XCTFail()
            return
        }
    }

    public func testLexiconNumber()
    {
        guard let number = Number("1234") else
        {
            XCTFail()
            return
        }

        let tree = SymbolTree.atom(AtomicValue.number(number))
        guard let particle = tree.particle else
        {
            XCTFail()
            return
        }
        let text = particle.structureText
        print(text)

        guard let p2 = text.particle else
        {
            XCTFail()
            return
        }

        guard let t2 = SymbolTree(particle: p2) else
        {
            XCTFail()
            return
        }

        guard t2 == tree else
        {
            XCTFail()
            return
        }
    }

    public func testLexiconData()
    {
        let data = Data("test".data)

        let tree = SymbolTree.atom(AtomicValue.data(data))
        guard let particle = tree.particle else
        {
            XCTFail()
            return
        }
        let text = particle.structureText
        print(text)

        guard let p2 = text.particle else
        {
            XCTFail()
            return
        }

        guard let t2 = SymbolTree(particle: p2) else
        {
            XCTFail()
            return
        }

        guard t2 == tree else
        {
            XCTFail()
            return
        }
    }

    public func testLexiconSymbolLexiconWordWord()
    {
        guard let key = Word("key") else
        {
            XCTFail()
            return
        }

        guard let value = Word("value") else
        {
            XCTFail()
            return
        }

        let tree = SymbolTree.lexicon(SymbolLexicon(keys: [key], values: [SymbolTree.atom(AtomicValue.word(value))]))
        guard let particle = tree.particle else
        {
            XCTFail()
            return
        }
        let text = particle.structureText
        print(text)

        guard let p2 = text.particle else
        {
            XCTFail()
            return
        }

        guard let t2 = SymbolTree(particle: p2) else
        {
            XCTFail()
            return
        }

        guard t2 == tree else
        {
            XCTFail()
            return
        }
    }

    public func testLexiconWordWord()
    {
        guard let a = Word("a") else
        {
            XCTFail()
            return
        }

        guard let b = Word("b") else
        {
            XCTFail()
            return
        }

        let tree = SymbolTree.lexicon(SymbolLexicon(keys: [nil, nil], values: [.atom(.word(a)), .atom(.word(b))]))
        guard let particle = tree.particle else
        {
            XCTFail()
            return
        }
        let text = particle.structureText
        print(text)

        guard let p2 = text.particle else
        {
            XCTFail()
            return
        }

        guard let t2 = SymbolTree(particle: p2) else
        {
            XCTFail()
            return
        }

        guard t2 == tree else
        {
            XCTFail()
            return
        }
    }

    public func testLexiconSymbolLexiconAABB()
    {
        guard let a = Word("a") else
        {
            XCTFail()
            return
        }

        guard let b = Word("b") else
        {
            XCTFail()
            return
        }

        let tree = SymbolTree.lexicon(SymbolLexicon(keys: [a, b], values: [.atom(.word(a)), .atom(.word(b))]))
        guard let particle = tree.particle else
        {
            XCTFail()
            return
        }
        let text = particle.structureText
        print(text)

        guard let p2 = text.particle else
        {
            XCTFail()
            return
        }

        guard let t2 = SymbolTree(particle: p2) else
        {
            XCTFail()
            return
        }

        guard t2 == tree else
        {
            XCTFail()
            return
        }
    }

    public func testLexiconSymbolLexiconABC()
    {
        guard let a = Word("a") else
        {
            XCTFail()
            return
        }

        guard let b = Word("b") else
        {
            XCTFail()
            return
        }

        guard let c = Word("c") else
        {
            XCTFail()
            return
        }

        let tree = SymbolTree.lexicon(
            SymbolLexicon(
                keys: [a],
                values: [
                    .lexicon(SymbolLexicon(
                        keys: [b],
                        values: [.atom(.word(c))]
                    ))
                ]
            )
        )

        guard let particle = tree.particle else
        {
            XCTFail()
            return
        }
        let text = particle.structureText
        print(text)

        guard let p2 = text.particle else
        {
            XCTFail()
            return
        }

        guard let t2 = SymbolTree(particle: p2) else
        {
            XCTFail()
            return
        }

        guard t2 == tree else
        {
            XCTFail()
            return
        }
    }

//    public func testLexiconDatable() throws
//    {
//        let lexicon = SymbolLexicon()
//        let word = Word("test")!
//        let _ = lexicon.append(key: nil, value: .atom(.word(word)))
//
//        let data = lexicon.data
//
//        guard let result = SymbolLexicon(data: data) else
//        {
//            XCTFail()
//            return
//        }
//
//        XCTAssertEqual(lexicon, result)
//    }

    public func testSymbolTreeString() throws
    {
        try symbolTreeStringHelper("test\n")
        try symbolTreeStringHelper("a b\n")
        try symbolTreeStringHelper("a b c\n")
        try symbolTreeStringHelper("a\nb\nc\n")
        try symbolTreeStringHelper("a\n\tb\n")
        try symbolTreeStringHelper("a\n\tb\n\tc\n")
        try symbolTreeStringHelper("a b c\n\td\n")
        try symbolTreeStringHelper("a\n\tb c\n")
        try symbolTreeStringHelper("a b\n\tc d\n")
        try symbolTreeStringHelper("a\n\tb\nc\n")
        try symbolTreeStringHelper("a b\n\tc d\ne f\n")
        try symbolTreeStringHelper("a\n\tb\n\t\tc\n")
        try symbolTreeStringHelper("test\n\t1 2\n\t3 4\n")
        try symbolTreeStringHelper("test\n\t1\n\t\t2\n")
        try symbolTreeStringHelper("test\n\t1 2\n\t\t3\n\t4 5\n\t\t6\n")
        try symbolTreeStringHelper("alpha beta\n\tdelta\n\t\tgamma\n")
        try symbolTreeStringHelper("1 2\n\t3\n\t\t4\n\t5\n6\n")
        try symbolTreeStringHelper("1.0 2e-10 1,000,000\n")
        try symbolTreeStringHelper("1 2\n\t3 4\n")
        try symbolTreeStringHelper("1 2 3\n\t4\n\t\t5 6 7\n")
        try symbolTreeStringHelper("1 2 3\n\t4\n\t\t5 6 7\n\t\t\t8 9 10 11\n\t12\n13 14 15\n")
        try symbolTreeStringHelper("test: value\n")
        try symbolTreeStringHelper("test: value again\n")
        try symbolTreeStringHelper("test: value again third\n")
        try symbolTreeStringHelper("test: value again third\n\tnested\n")
        try symbolTreeStringHelper("test: value again third\n\tnested again\n")
        try symbolTreeStringHelper("test: value again third\n\tnested again third\n")
        try symbolTreeStringHelper("test: value again third\n\tnested again third\n")
        try symbolTreeStringHelper("test: value again third\n\tnested again third\n\t\tnestedmore\n")
        try symbolTreeStringHelper("test: value again third\n\tnested again third\n\t\tnestedmore\ntrailing\n")
        try symbolTreeStringHelper("test: value again third\n\tkey: nested again third\n\t\tnestedmore\ntrailing\n")
        try symbolTreeStringHelper("test: value again third\n\tkey: nested again third\n\t\twow: nestedmore\ntrailing\n")
        try symbolTreeStringHelper("a: b\nc: d\n")
        try symbolTreeStringHelper("a: b\nc: d\ne:\n\tf\n\tg\n")
        try symbolTreeStringHelper("a: b\nc: d\ne:\n\tf f2\n\tg g2\n")
    }

    public func symbolTreeStringHelper(_ input: String) throws
    {
        print("input : \(input)")

        let parser = try Parser(input)
        let lexicon = try SymbolLexicon(top: parser.top.trees!)
        let tree = SymbolTree.lexicon(lexicon)
        print("tree  : \(tree.description)")

        let result = try tree.string()
        print("result: \(result)")

        XCTAssertEqual(result, input)
    }

    public func testTokenizer() throws
    {
        try tokenizerHelper("test\n")
        try tokenizerHelper("a b\n")
        try tokenizerHelper("a b c\n")
        try tokenizerHelper("a\nb\nc\n")
        try tokenizerHelper("a\n\tb\n")
        try tokenizerHelper("a\n\tb\n\t\tc\n")
        try tokenizerHelper("alpha beta\n\tdelta\n\t\tgamma\n")
        try tokenizerHelper("1 2\n\t3\n\t\t4\n\t5\n6\n")
        try tokenizerHelper("1.0 2e-10 1,000,000\n")
        try tokenizerHelper("1 2\n\t3 4\n")
        try tokenizerHelper("1 2 3\n\t4\n\t\t5 6 7\n")
        try tokenizerHelper("1 2 3\n\t4\n\t\t5 6 7\n\t\t\t8 9 10 11\n\t12\n13 14 15\n")
    }

    public func testParser() throws
    {
        try parserHelper("test\n", "((test)) ")
        try parserHelper("a b\n", "((a b)) ")
        try parserHelper("a\nb\n", "((a) (b)) ")
        try parserHelper("a b c\n", "((a b c)) ")
        try parserHelper("a\nb\nc\n", "((a) (b) (c)) ")
        try parserHelper("a\n\tb\n", "((a (b))) ")
        try parserHelper("a b\n\tc\n", "((a b (c))) ")
        try parserHelper("a b c\n\td\n", "((a b c (d))) ")
        try parserHelper("a\n\tb c\n", "((a (b c))) ")
        try parserHelper("a b\n\tc d\n", "((a b (c d))) ")
        try parserHelper("a\n\tb\nc\n", "((a (b)) (c)) ")
        try parserHelper("a b\n\tc d\ne f\n", "((a b (c d)) (e f)) ")
        try parserHelper("a\n\tb\n\t\tc\n", "((a (b (c)))) ")
        try parserHelper("alpha beta\n\tdelta\n\t\tgamma\n", "((alpha beta (delta (gamma)))) ")
        try parserHelper("1 2\n\t3\n\t\t4\n\t5\n6\n", "((1 2 (3 (4)) (5)) (6)) ")
        try parserHelper("1.0 2e-10 1,000,000\n", "((1.0 2e-10 1,000,000)) ")
        try parserHelper("1 2\n\t3 4\n", "((1 2 (3 4))) ")
        try parserHelper("1 2 3\n\t4\n\t\t5 6 7\n", "((1 2 3 (4 (5 6 7)))) ")
        try parserHelper("1 2 3\n\t4\n\t\t5 6 7\n\t\t\t8 9 10 11\n\t12\n13 14 15\n", "((1 2 3 (4 (5 6 7 (8 9 10 11))) (12)) (13 14 15)) ")
    }

    public func testLexicalTyping() throws
    {
        try parserHelper("test: value\n")
        try parserHelper("test: value again\n")
        try parserHelper("test: value again third\n")
        try parserHelper("test: value again third\n\tnested\n")
        try parserHelper("test: value again third\n\tnested again\n")
        try parserHelper("test: value again third\n\tnested again third\n")
        try parserHelper("test: value again third\n\tnested again third\n")
        try parserHelper("test: value again third\n\tnested again third\n\t\tnestedmore\n")
        try parserHelper("test: value again third\n\tnested again third\n\t\tnestedmore\ntrailing\n")
        try parserHelper("test: value again third\n\tkey: nested again third\n\t\tnestedmore\ntrailing\n")
        try parserHelper("test: value again third\n\tkey: nested again third\n\t\twow: nestedmore\ntrailing\n")
    }

    public func testSymbolic() throws
    {
        try symbolicHelper("test\n")
        try symbolicHelper("a b\n")
        try symbolicHelper("a b c\n")
        try symbolicHelper("a\nb\nc\n")
        try symbolicHelper("a\n\tb\n")
        try symbolicHelper("a\n\tb\n\tc\n")
        try symbolicHelper("a b c\n\td\n")
        try symbolicHelper("a\n\tb c\n")
        try symbolicHelper("a b\n\tc d\n")
        try symbolicHelper("a\n\tb\nc\n")
        try symbolicHelper("a b\n\tc d\ne f\n")
        try symbolicHelper("a\n\tb\n\t\tc\n")
        try symbolicHelper("test\n\t1 2\n\t3 4\n")
        try symbolicHelper("test\n\t1\n\t\t2\n")
        try symbolicHelper("test\n\t1 2\n\t\t3\n\t4 5\n\t\t6\n")
        try symbolicHelper("alpha beta\n\tdelta\n\t\tgamma\n")
        try symbolicHelper("1 2\n\t3\n\t\t4\n\t5\n6\n")
        try symbolicHelper("1.0 2e-10 1,000,000\n")
        try symbolicHelper("1 2\n\t3 4\n")
        try symbolicHelper("1 2 3\n\t4\n\t\t5 6 7\n")
        try symbolicHelper("1 2 3\n\t4\n\t\t5 6 7\n\t\t\t8 9 10 11\n\t12\n13 14 15\n")
        try symbolicHelper("test: value\n", "((test: (value )))")
        try symbolicHelper("test: value again\n", "((test: (value again )))")
        try symbolicHelper("test: value again third\n", "((test: (value again third )))")
        try symbolicHelper("test: value again third\n\tnested\n", "((test: (value again third (nested ))))")
        try symbolicHelper("test: value again third\n\tnested again\n", "((test: (value again third (nested again ))))")
        try symbolicHelper("test: value again third\n\tnested again third\n", "((test: (value again third (nested again third ))))")
        try symbolicHelper("test: value again third\n\tnested again third\n", "((test: (value again third (nested again third ))))")
        try symbolicHelper("test: value again third\n\tnested again third\n\t\tnestedmore\n", "((test: (value again third (nested again third (nestedmore )))))")
        try symbolicHelper("test: value again third\n\tnested again third\n\t\tnestedmore\ntrailing\n", "((test: (value again third (nested again third (nestedmore ))))(trailing ))")
        try symbolicHelper("test: value again third\n\tkey: nested again third\n\t\tnestedmore\ntrailing\n", "((test: (value again third (key: (nested again third (nestedmore )))))(trailing ))")
        try symbolicHelper("test: value again third\n\tkey: nested again third\n\t\twow: nestedmore\ntrailing\n", "((test: (value again third (key: (nested again third (wow: (nestedmore ))))))(trailing ))")
        try symbolicHelper("a: b\nc: d\n", "((a: (b ))(c: (d )))")
        try symbolicHelper("a: b\nc: d\ne:\n\tf\n\tg\n", "((a: (b ))(c: (d ))(e: ((f )(g ))))")
        try symbolicHelper("a: b\nc: d\ne:\n\tf f2\n\tg g2\n", "((a: (b ))(c: (d ))(e: ((f f2 )(g g2 ))))")
    }

    public func testSymbolicResources() throws
    {
        let path = "/Users/dr.brandonwiley/Sculpture/Resources/Sculpture/Types"
        guard let files = File.contentsOfDirectory(atPath: path) else
        {
            XCTFail()
            return
        }

        for file in files
        {
            let filepath = path + "/" + file
            let data = try Data(contentsOf: URL(fileURLWithPath: filepath))
            let string = data.string
            print(filepath)
            print(string)
            try symbolicHelper(string)
        }
    }

    public func tokenizerHelper(_ input: String) throws
    {
        let tokenizer = try Tokenizer(string: input)
        print(tokenizer.tokens)

        let result = Formatter.format(tokens: tokenizer.tokens)
        print("--------------------")
        print("input:")
        print(input)
        print("--------------------")
        print("internal:")
        print(result)
        print("--------------------")
        print("output:")
        print(result)
        print("--------------------")
        XCTAssertEqual(result, input)
    }

    public func parserHelper(_ input: String, _ correct: String? = nil) throws
    {
        let top = try Parser.parseTree(input)
        print(top)

        let unparser = try Parser(top)
        print(unparser.string)

        print("--------------------")
        print("input:")
        print(input)
        print("--------------------")
        print("internal:")
        print(top)
        print("--------------------")
        print("output:")
        print(unparser.string)
        print("--------------------")

        if let correct = correct
        {
            XCTAssertEqual(top.description, correct)
        }

        XCTAssertEqual(unparser.string, input)
    }

    public func symbolicHelper(_ input: String, _ correct: String? = nil) throws
    {
        let correctResult: String = input

        let parser = try Parser(input)
        print(parser.top)

        let lexicon = try SymbolLexicon(top: parser.top.trees!)
        let symbols = SymbolTree.lexicon(lexicon)
        symbols.display()

//        let unparser = try Parser(symbols)
//        let result = unparser.string
//        print("--------------------")
//        print("input:")
//        print(input)
//        print("--------------------")
//        print("internal:")
//        print(symbols.description)
//        print("--------------------")
//        print("output:")
//        print(result)
//        print("--------------------")

//        if let correct = correct
//        {
//            XCTAssertEqual(symbols.description, correct)
//        }
//        else
//        {
//            XCTAssertEqual(result, correctResult)
//        }
    }

    public func testBasicStructuralTypingResources() throws
    {
        let path = "/Users/dr.brandonwiley/Sculpture/Resources/Sculpture/BasicValues"
        let typepath = "/Users/dr.brandonwiley/Sculpture/Resources/Sculpture/ValueTypes"

        guard let files = File.contentsOfDirectory(atPath: path) else
        {
            XCTFail()
            return
        }

        for file in files
        {
            let filepath = path + "/" + file
            let data = try Data(contentsOf: URL(fileURLWithPath: filepath))
            let string = data.string
            print(filepath)
            print(string)

            let typefilepath = typepath + "/" + file
            let typedata = try Data(contentsOf: URL(fileURLWithPath: typefilepath))
            let typestring = typedata.string
            print(typefilepath)
            print(typestring)

            try basicHelper(string, typestring)
        }
    }

    public func basicHelper(_ input: String, _ type: String) throws
    {
        let parser = try Parser(input)
        let lexicon = try SymbolLexicon(top: parser.top.trees!)
        let symbols = SymbolTree.lexicon(lexicon)
        let focus = try Focus<SymbolTree>(tree: symbols)
        let valueFocus = try focus.narrow(.index(Index(0)!)).narrow(.index(Index(0)))
        symbols.display()

        let typeparser = try Parser(type)
        let typelexicon = try SymbolLexicon(top: typeparser.top.trees!)
        let typesymbols = SymbolTree.lexicon(typelexicon)
        let typefocus = try Focus<SymbolTree>(tree: typesymbols)
        let literalFocus = try typefocus.narrow(.index(Index(0)!)).narrow(.index(Index(0)!))
        typesymbols.display()

        let maybeLiteral = try LiteralType(focus: literalFocus)
        XCTAssertNotNil(maybeLiteral)
        guard let literal = maybeLiteral else {return}
        let result = try literal.check(context: typefocus, value: valueFocus)
        print("result: \(result) for \(symbols.description) : \(typesymbols.description)")

        XCTAssertTrue(result)
    }

    public func testStructuralTypingResources() throws
    {
        let path = "/Users/dr.brandonwiley/Sculpture/Resources/Sculpture/StructuralValues"
        let typepath = "/Users/dr.brandonwiley/Sculpture/Resources/Sculpture/ValueTypes"

        guard let files = File.contentsOfDirectory(atPath: path) else
        {
            XCTFail()
            return
        }

        for file in files
        {
            let filepath = path + "/" + file
            let data = try Data(contentsOf: URL(fileURLWithPath: filepath))
            let string = data.string
            print(filepath)
            print(string)

            let typefilepath = typepath + "/" + file
            let typedata = try Data(contentsOf: URL(fileURLWithPath: typefilepath))
            let typestring = typedata.string
            print(typefilepath)
            print(typestring)

            try structuralHelper(string, typestring)
        }
    }

    public func testStructuralTyping() throws
    {
        try structuralHelper("0\n", "basic.int\n")
        try structuralHelper("0\n", "basic.float\n")
        try structuralHelper("0xFF\n", "basic.data\n")
        try structuralHelper("0 1\n", "structure basic.int basic.int\n")
        try structuralHelper("0 1\n", "sequence basic.int\n")
        try structuralHelper("0\n", "choice basic.int\n\tsequence basic.int\n")
    }

    public func structuralHelper(_ input: String, _ type: String) throws
    {
        let parser = try Parser(input)
        let lexicon = try SymbolLexicon(top: parser.top.trees!)
        let symbols = SymbolTree.lexicon(lexicon)
        let focus = try Focus<SymbolTree>(tree: symbols)
        var valueFocus = try focus.narrow(.index(Index(0)!))
        if try valueFocus.count() == 1
        {
            valueFocus = try valueFocus.narrow(.index(Index(0)!))
        }
        symbols.display()
        print()

        let typeparser = try Parser(type)
        let typelexicon = try SymbolLexicon(top: typeparser.top.trees!)
        let typesymbols = SymbolTree.lexicon(typelexicon)
        let typefocus = try Focus<SymbolTree>(tree: typesymbols)
        var literalFocus = try typefocus.narrow(.index(Index(0)!))
        if try literalFocus.count() == 1
        {
            literalFocus = try literalFocus.narrow(.index(Index(0)!))
        }
        typesymbols.display()
        print()

        do
        {
            let maybeLiteral = try LiteralType(focus: literalFocus)
            XCTAssertNotNil(maybeLiteral)
            guard let literal = maybeLiteral else
            {
                return
            }
            let result = try literal.check(context: literalFocus, value: valueFocus)
            print("result: \(result) for \(symbols.description) : \(typesymbols.description)")

            XCTAssertTrue(result)
        }
        catch
        {
            print(error)
        }
    }
}
