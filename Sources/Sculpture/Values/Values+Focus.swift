//
//  Values+Focus.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/28/21.
//

import Foundation
import Focus

extension Value
{
    public var literal: LiteralValue?
    {
        return self.literalPrism.tryGet(self)
    }

    public var literalPrism: SimplePrism<Value, LiteralValue>
    {
        SimplePrism<Value, LiteralValue>(
            tryGet:
                {
                    (value: Value) -> LiteralValue? in

                    switch value
                    {
                        case .literal(let value):
                            return value
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (literal: LiteralValue) -> Value in

                    return .literal(literal)
                }
        )
    }

    public var named: NamedReferenceValue?
    {
        return self.namedPrism.tryGet(self)
    }

    public var namedPrism: SimplePrism<Value, NamedReferenceValue>
    {
        SimplePrism<Value, NamedReferenceValue>(
            tryGet:
                {
                    (value: Value) -> NamedReferenceValue? in

                    switch value
                    {
                        case .named(let value):
                            return value
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (named: NamedReferenceValue) -> Value in

                    return .named(named)
                }
        )
    }

    public var reference: ReferenceValue?
    {
        return self.referencePrism.tryGet(self)
    }

    public var referencePrism: SimplePrism<Value, ReferenceValue>
    {
        SimplePrism<Value, ReferenceValue>(
            tryGet:
                {
                    (value: Value) -> ReferenceValue? in

                    switch value
                    {
                        case .reference(let value):
                            return value
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (value: ReferenceValue) -> Value in

                    return .reference(value)
                }
        )
    }
}

extension LiteralValue
{
    public var basic: BasicValue?
    {
        return self.basicPrism.tryGet(self)
    }

    public var basicPrism: SimplePrism<LiteralValue, BasicValue>
    {
        SimplePrism<LiteralValue, BasicValue>(
            tryGet:
                {
                    (value: LiteralValue) -> BasicValue? in

                    switch value
                    {
                        case .basic(let value):
                            return value
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (value: BasicValue) -> LiteralValue in

                    return .basic(value)
                }
        )
    }

    public var cryptographic: CryptographicValue?
    {
        return self.cryptographicPrism.tryGet(self)
    }

    public var cryptographicPrism: SimplePrism<LiteralValue, CryptographicValue>
    {
        SimplePrism<LiteralValue, CryptographicValue>(
            tryGet:
                {
                    (value: LiteralValue) -> CryptographicValue? in

                    switch value
                    {
                        case .cryptographic(let value):
                            return value
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (value: CryptographicValue) -> LiteralValue in

                    return .cryptographic(value)
                }
        )
    }
}

extension BasicValue
{
    public var boolean: Bool?
    {
        return self.booleanPrism.tryGet(self)
    }

    public var booleanPrism: SimplePrism<BasicValue, Bool>
    {
        SimplePrism<BasicValue, Bool>(
            tryGet:
                {
                    (value: BasicValue) -> Bool? in

                    switch value
                    {
                        case .boolean(let value):
                            return value
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (value: Bool) -> BasicValue in

                    return .boolean(value)
                }
        )
    }

    public var bytes: Data?
    {
        return self.bytesPrism.tryGet(self)
    }

    public var bytesPrism: SimplePrism<BasicValue, Data>
    {
        SimplePrism<BasicValue, Data>(
            tryGet:
                {
                    (value: BasicValue) -> Data? in

                    switch value
                    {
                        case .bytes(let value):
                            return value
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (value: Data) -> BasicValue in

                    return .bytes(value)
                }
        )
    }
}
