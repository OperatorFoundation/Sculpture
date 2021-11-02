import XCTest
@testable import Sculpture
import SculptureNetwork

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
}
