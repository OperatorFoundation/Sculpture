//
//  SculptureConnection.swift
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

import Sculpture

public class SculptureConnection
{
    let connection: Connection
    let remote: RemoteDatabase = RemoteDatabase() // Per-connection RPC database
    let queue: DispatchQueue = DispatchQueue(label: "SculptureConnection.processResults")
    let loggingTag: String

    public convenience init?(host: String, port: Int, loggingTag: String = "")
    {
        guard let connection = TransmissionConnection(host: host, port: port) else {return nil}
        self.init(connection: connection, loggingTag: loggingTag)
    }

    public init(connection: Connection, loggingTag: String)
    {
        self.connection = connection
        self.loggingTag = loggingTag
    }

    public func write(entity: Entity) -> Bool
    {
        let data = entity.data

        print("\(loggingTag) writing: \(data.count)")
        return self.connection.write(data: data)
    }

    public func read() -> Entity?
    {
        guard let countBytes = self.connection.read(size: 8) else {return nil}
        print("\(loggingTag) \(Thread.current) read \(countBytes.count)")
        guard let count = countDataToCount(countBytes) else {return nil}
        let intCount = Int(count)

        guard let rest = self.connection.read(size: intCount) else {return nil}
        print("\(loggingTag) read: \(rest.count)/\(intCount)")

        let entityData = countBytes + rest

        return Entity(data: entityData)
    }
}
