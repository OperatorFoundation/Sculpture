//
//  ValueArchive.swift
//
//
//  Created by Dr. Brandon Wiley on 12/3/21.
//

import Foundation
import Datable
import SwiftHexTools
import Gardener

public class ValueArchive: ValueStore
{
    public typealias Element = Value
    public typealias Iterator = ValueArchiveIterator
    // Warning: this will break if Structure+Datable changes the Data encoding for:
    // Entity
    // sequenceCountIndex = entityType
    // count is length 8
    let entityCountIndex = 1
    var entityCount: Int

    // Warning: this will break if Values+Datable changes the Data encoding for:
    // Entity, Value, Literal, or SequenceValue
    // sequenceTypeNameCount = entityType + entityCount + literalType + sequenceType
    // count is length 8
    let sequenceTypeNameCountIndex = 1 + 8 + 1 + 1
    let sequenceTypeNameCount: Int
    let sequenceTypeNameIndex: Int
    let sequenceTypeName: String
    let sequenceCountIndex: Int
    var sequenceCount: Int

    let type: String
    var data: Data

    var empty: Bool
    var currentIndex: Int = 0

    var sequence: SequenceValue

    public init?(path: String, type: String)
    {
        self.type = type

        let url = URL(fileURLWithPath: path)
        if File.exists(path)
        {
            self.empty = false

            do
            {
                data = try Data(contentsOf: url, options: .alwaysMapped)
            }
            catch
            {
                // File exists, but is unreadable
                return nil
            }

            self.entityCount = 0
            self.sequenceTypeNameCount = type.count
            self.sequenceTypeNameIndex = self.sequenceTypeNameCountIndex+8
            self.sequenceTypeName = type
            self.sequenceCountIndex = self.sequenceTypeNameIndex+self.sequenceTypeNameCount
            self.sequenceCount = 0

            guard let sequence = SequenceValue(data: self.data) else {return nil}
            self.sequence = sequence
        }
        else
        {
            self.empty = true

            do
            {
                try "".write(to: url, atomically: true, encoding: .utf8)
                data = try Data(contentsOf: url, options: .alwaysMapped)
            }
            catch
            {
                // New file is unwritable or unreadable or both
                return nil
            }

            self.entityCount = Int(self.data[self.entityCountIndex..<self.entityCountIndex+8].maybeNetworkUint64!)
            self.sequenceTypeNameCount = Int(self.data[self.sequenceTypeNameCountIndex..<self.sequenceTypeNameCountIndex+8].maybeNetworkUint64!)
            self.sequenceTypeNameIndex = self.sequenceTypeNameCountIndex+8
            self.sequenceTypeName = self.data[self.sequenceTypeNameIndex..<self.sequenceTypeNameIndex+self.sequenceTypeNameCount].string
            self.sequenceCountIndex = self.sequenceTypeNameIndex+self.sequenceTypeNameCount
            self.sequenceCount = Int(self.data[self.sequenceCountIndex..<self.sequenceCountIndex+8].maybeNetworkUint64!)

            // Type mismatch
            guard self.sequenceTypeName == type else {return nil}

            self.sequence = SequenceValue(self.type, [])
        }
    }

    public func put(_ value: Value) -> Bool
    {
        self.sequence.contents.append(value)

        if self.empty
        {
            let seq: SequenceValue = SequenceValue(self.type, [value])
            let list: Entity = .value(.literal(.sequence(seq)))
            self.data.append(list.data)

            self.empty = false
        }
        else
        {
            let newData = value.data
            self.data.append(newData)

            self.entityCount += newData.count
            let newEntityCountData = UInt64(self.entityCount).maybeNetworkData!
            self.data.replaceSubrange(self.entityCountIndex..<self.entityCountIndex+8, with: newEntityCountData)

            self.sequenceCount += newData.count
            let newSequenceCountData = UInt64(self.sequenceCount).maybeNetworkData!
            self.data.replaceSubrange(self.sequenceCount..<self.sequenceCount+8, with: newSequenceCountData)
        }

        return true
    }

    public func makeIterator() -> ValueArchiveIterator
    {
        return ValueArchiveIterator(self.sequence.contents)
    }
}

public struct ValueArchiveIterator: IteratorProtocol
{
    public typealias Element = Value

    let values: [Value]
    var currentIndex: Int = 0

    public init(_ values: [Value])
    {
        self.values = values
    }

    public func next() -> Value?
    {
        if self.currentIndex < self.values.count
        {
            return self.values[self.currentIndex]
        }
        else
        {
            return nil
        }
    }
}
