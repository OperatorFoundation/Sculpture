import XCTest
@testable import Sculpture

final class SculptureTests: XCTestCase {
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
    }

    func testType()
    {
        let correct = Type.literal(.basic(.string))

        let data = correct.data
        let maybeResult = Type(data: data)

        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
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
    }

    func testSequence()
    {
        let correct = Sequence(Type.literal(.choice(Choice("TestChoice", []))))

        let data = correct.data
        let maybeResult = Sequence(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
    }

    func testPropertyBasicString()
    {
        let correct = Property("name", type: Type.literal(.basic(.string)))

        let data = correct.data
        let maybeResult = Property(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
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
    }

    func testSequenceValue()
    {
        let correct = SequenceValue("String", [])

        let data = correct.data
        let maybeResult = SequenceValue(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
    }

    func testSequenceValueString()
    {
        let correct = SequenceValue("String", [.literal(.basic(.string("test")))])

        let data = correct.data
        let maybeResult = SequenceValue(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
    }

    func testPropertyValueBasicString()
    {
        let correct = Value.literal(.basic(BasicValue.string("test")))

        let data = correct.data
        let maybeResult = Value(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
    }

    func testStructureInstance()
    {
        let correct = StructureInstance("Test", values: [Value.literal(.basic(.string("test")))])

        let data = correct.data
        let maybeResult = StructureInstance(data: data)
        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
    }

    func testValue()
    {
        let correct = Value.literal(.basic(.string("test")))

        let data = correct.data
        let maybeResult = Value(data: data)

        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
    }

    func testEntityValue()
    {
        let correct = Entity.value(.literal(.basic(.string("test"))))

        let data = correct.data
        let maybeResult = Entity(data: data)

        XCTAssertNotNil(maybeResult)
        guard let result = maybeResult else {return}

        XCTAssertEqual(result, correct)
    }
}
