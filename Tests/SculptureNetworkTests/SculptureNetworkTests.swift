import XCTest
@testable import Sculpture
import SculptureNetwork
import Crypto

final class SculptureNetworkTests: XCTestCase {
    func testRemoteListener()
    {
        let success = XCTestExpectation(description: "success return value")

        let name = "ping"
        let value = Value.literal(.basic(.string("pong")))

        let pingInterface = NamedFunction(
            "ping",
            FunctionSignature([], .literal(.basic(.string)))
        )

        let pingImplementation: FunctionImplementation = {
            this, arguments in

            return this
        }

        let interface = Interface("ping", [pingInterface])
        let functions = [pingInterface: pingImplementation]
        let implementation = InterfaceImplementation(interface, functions)

        guard let listener = RemoteListener(port: 1234, name: name, value: value, implementation: implementation) else
        {
            XCTFail()
            return
        }

        let queue = DispatchQueue(label: "testListener")
        queue.async
        {
            listener.accept()
        }

        Thread.sleep(forTimeInterval: 1)

        guard let client = SculptureConnection(host: "127.0.0.1", port: 1234, loggingTag: "Client") else
        {
            XCTFail()
            return
        }

        let target = Value.named(NamedReferenceValue("ping"))
        let signature = FunctionSignature([], Type.literal(.basic(.string)))
        let selector = Sculpture.Selector("ping", signature: signature)
        client.call(target, selector: selector, arguments: [])
        {
            result in

            switch result
            {
                case .value(let value):
                    print("Success: \(value)")
                    success.fulfill()
                case .failure:
                    print("Failure")
            }
        }
        client.processResults()

        wait(for: [success], timeout: 60) // 60 seconds
    }

    func testRemoteCryptographic()
    {
        let success = XCTestExpectation(description: "success return value")

        let document = "hello".data
        let privateKey = P256.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        var hasher = SHA256()
        hasher.update(data: document)
        let hash = hasher.finalize()
        let hashData = Data(hash)
        guard let signature = try? privateKey.signature(for: hash) else
        {
            XCTFail()
            return
        }

        let functionSignature: FunctionSignature = FunctionSignature(
            [
                Type.literal(.basic(.bytes)),
                Type.literal(.cryptographic(.p256SigningPublic)),
                Type.literal(.cryptographic(.p256Signature))
            ],
            Type.literal(.basic(.boolean))
        )

        let archiveInterface = NamedFunction(
            "archive",
            functionSignature
        )

        let archiveImplementation: FunctionImplementation = {
            this, arguments in

            let success: Value = .literal(.basic(.boolean(true)))
            let failure: Value = .literal(.basic(.boolean(false)))

            guard arguments.count == 3 else {return failure}
            guard let data = arguments[0].literal?.basic?.bytes else {return failure}
            guard let signator = arguments[1].literal?.cryptographic?.p256SigningPublic else {return failure}
            guard let signature = arguments[2].literal?.cryptographic?.p256Signature else {return failure}

            var hasher = SHA256()
            hasher.update(data: data)
            let digest = hasher.finalize()
            let valid = signator.isValidSignature(signature, for: digest)

            if valid
            {
                return success
            }
            else
            {
                return failure
            }
        }

        let interface = Interface("archive", [archiveInterface])
        let functions = [archiveInterface: archiveImplementation]
        let implementation = InterfaceImplementation(interface, functions)

        guard let listener = RemoteListener(port: 1234, name: "Archive", value: .literal(.basic(.boolean(true))), implementation: implementation) else
        {
            XCTFail()
            return
        }

        let queue = DispatchQueue(label: "archiveListener")
        queue.async
        {
            listener.accept()
        }

        Thread.sleep(forTimeInterval: 1)

        let arguments: [Value] = [
            .literal(.basic(.bytes(document))),
            .literal(.cryptographic(.p256SigningPublic(publicKey))),
            .literal(.cryptographic(.p256Signature(signature)))
        ]

        guard let client = SculptureConnection(host: "127.0.0.1", port: 1234, loggingTag: "Client") else
        {
            XCTFail()
            return
        }

        let target = Value.named(NamedReferenceValue("Archive"))
        let selector = Sculpture.Selector("archive", signature: functionSignature)
        client.call(target, selector: selector, arguments: arguments)
        {
            result in

            switch result
            {
                case .value(let value):
                    print("Success: \(value)")
                    guard let bool = value.literal?.basic?.boolean else
                    {
                        XCTFail()
                        return
                    }

                    if bool
                    {
                        success.fulfill()
                        return
                    }
                    else
                    {
                        XCTFail()
                        return
                    }
                case .failure:
                    print("Failure")
            }
        }
        client.processResults()

        wait(for: [success], timeout: 60) // 60 seconds
    }

}
