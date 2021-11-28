//
//  Remote.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/31/21.
//

import Foundation
import Sculpture

public class RemoteDatabase
{
    var database: [UInt64: Promise] = [:]

    public init()
    {
    }

    public func put(_ call: Call, _ callback: @escaping Completion)
    {
        let promise = Promise(call, callback)
        self.database[call.identifier] = promise
    }

    public func get(_ identifier: UInt64) -> Promise?
    {
        return self.database[identifier]
    }

    public func complete(_ result: Result)
    {
        guard let promise: Promise = self.database[result.identifier] else {return}
        self.database.removeValue(forKey: result.identifier)

        promise.callback(result.value)
    }
}

public typealias Completion = (ResultValue) -> Void

public struct Promise
{
    public let call: Call
    public let callback: Completion

    public init(_ call: Call, _ callback: @escaping Completion)
    {
        self.call = call
        self.callback = callback
    }
}

extension SculptureConnection
{
    public func call(_ target: Value, selector: Sculpture.Selector, arguments: [Value], callback: @escaping Completion)
    {
        guard let call = Call(target, selector, arguments) else
        {
            callback(.failure)
            return
        }

        let entity = Entity.flow(.call(call))
        guard self.write(entity: entity) else
        {
            callback(.failure)
            return
        }

        self.remote.put(call, callback)
    }

    public func processResults()
    {
        guard let entity = self.read() else {return}

        switch entity
        {
            case .flow(let flow):
                switch flow
                {
                    case .result(let result):
                        self.remote.complete(result)
                    default:
                        return
                }
            default:
                return
        }
    }
}

public class RemoteDatabaseServer
{
    var targets: [String: Value] = [:]
    var implementations: [String: InterfaceImplementation] = [:]

    public init()
    {
    }

    public func put(_ name: String, _ value: Value)
    {
        self.targets[name] = value
    }

    public func get(_ name: String) -> Value?
    {
        return self.targets[name]
    }

    public func implement(_ name: String, _ implementation: InterfaceImplementation)
    {
        self.implementations[name] = implementation
    }

    public func select(_ target: String, _ selector: Sculpture.Selector) -> FunctionImplementation?
    {
        guard let interfaceImplementation = self.implementations[target] else {return nil}
        return interfaceImplementation.select(selector)
    }

    public func processCalls(_ connection: SculptureConnection)
    {
        while true
        {
            print("RemoteDatabaseServer.processCalls")
            guard let callEntity = connection.read() else {return}
            print("read callEntity")

            switch callEntity
            {
                case .flow(let flow):
                    switch flow
                    {
                        case .call(let call):
                            switch call.target
                            {
                                case .named(let named):
                                    guard let target = self.get(named.name) else {continue}
                                    guard let function = self.select(named.name, call.selector) else {continue}
                                    let maybeFunctionResult = function(target, call.arguments)
                                    if let functionResult = maybeFunctionResult
                                    {
                                        let result = Result(call.identifier, ResultValue.value(functionResult))
                                        let entity = Entity.flow(.result(result))

                                        let _ = connection.write(entity: entity)
                                    }
                                    else
                                    {
                                        let result = Result(call.identifier, ResultValue.failure)
                                        let entity = Entity.flow(.result(result))

                                        let _ = connection.write(entity: entity)
                                    }
                                default:
                                    continue
                            }
                        default:
                            continue
                    }
                default:
                    continue
            }
        }
    }
}

public class RemoteListener
{
    let listener: SculptureListener
    let name: String
    let value: Value
    let implementation: InterfaceImplementation
    let queue = DispatchQueue(label: "RemoteListener")

    public init?(port: Int, name: String, value: Value, implementation: InterfaceImplementation)
    {
        guard let listener = SculptureListener(port: port) else {return nil}
        self.listener = listener

        self.name = name
        self.value = value
        self.implementation = implementation
    }

    public func accept()
    {
        guard let connection = self.listener.accept() else {return}

        let remote = RemoteDatabaseServer()
        remote.put(self.name, self.value)
        remote.implement(self.name, self.implementation)

        queue.async
        {
            remote.processCalls(connection)
        }
    }
}
