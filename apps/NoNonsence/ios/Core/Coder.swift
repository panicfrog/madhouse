//
//  Coder.swift
//  NoNonsence
//
//  Created by 叶永平 on 2024/7/11.
//

import Foundation
import MessagePack

public final class MsgpackCoder: DataCoder {
  public func encode<T>(_ value: T) throws -> Data where T : Decodable, T : Encodable {
    let encoder = MessagePackEncoder()
    return try encoder.encode(value)
  }
  
  public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable, T : Encodable {
    let decoder = MessagePackDecoder()
    return try decoder.decode(type, from: data)
  }
  
    
}
