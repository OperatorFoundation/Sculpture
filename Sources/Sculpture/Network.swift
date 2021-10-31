//
//  File.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/20/21.
//

import Foundation

#if os(macOS) || os(iOS)
import Transmission
#else
import TransmissionLinux
#endif

public class SculptureConnection
{
    let connection: Connection

    public init?(host: String, port: Int)
    {
        guard let connection = Connection(host: host, port: port) else {return nil}
        self.connection = connection
    }

    public func write(entity: Entity) -> Bool
    {
        let data = entity.data
        return self.connection.write(data: data)
    }

    public func read() -> Entity?
    {
        guard let countBytes = self.connection.read(size: 8) else {return nil}
        guard let count = countDataToCount(countBytes) else {return nil}
        let intCount = Int(count)

        guard let rest = self.connection.read(size: intCount) else {return nil}

        let typeByte = rest[0]
        let remainder = Data(rest[1...])

        guard let type = Entities(rawValue: typeByte) else {return nil}
        switch type
        {
            case .type:
                guard let type = Type(data: remainder) else {return nil}
                return .type(type)
            case .value:
                guard let value = Value(data: remainder) else {return nil}
                return .value(value)
            case .flow:
                guard let flow = Flow(data: remainder) else {return nil}
                return .flow(flow)
        }
    }
}
