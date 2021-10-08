//
//  Structure.swift
//
//  Created by Dr. Brandon Wiley on 9/29/21.
//

import Foundation
import Datable

public indirect enum Entity: Equatable
{
    case type(Type)
    case value(Value)
}
