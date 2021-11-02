//
//  SculptureListener.swift
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

public class SculptureListener
{
    let listener: Listener
    let queue: DispatchQueue = DispatchQueue(label: "SculptureConnection.processResults")

    public convenience init?(port: Int)
    {
        guard let listener = Listener(port: port) else {return nil}
        self.init(listener: listener)
    }

    public init(listener: Listener)
    {
        self.listener = listener
    }

    public func accept() -> SculptureConnection?
    {
        let connection = self.listener.accept()
        return SculptureConnection(connection: connection, loggingTag: "Listener")
    }
}
