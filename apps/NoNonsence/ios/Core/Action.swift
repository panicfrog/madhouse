//
//  Action.swift
//  NoNonsence
//
//  Created by 叶永平 on 2024/7/11.
//

import Foundation

public typealias Action00 = () -> Void                // Void -> Void
public typealias Action01 = () throws -> Data         // Void -> Data
public typealias Action02 = () throws -> Data?        // Void -> Data?

public typealias Action10 = (Data) throws -> Void     // Data -> Void
public typealias Action11 = (Data) throws -> Data     // Data -> Data
public typealias Action12 = (Data) throws -> Data?    // Data -> Data?

public typealias Action20 = (Data?) throws -> Void    // Data? -> Void
public typealias Action21 = (Data?) throws -> Data    // Data? -> Data
public typealias Action22 = (Data?) throws -> Data?   // Data? -> Data?

public enum ActionType {
  case action00(Action00)
  case action01(Action01)
  case action02(Action02)
  case action10(Action10)
  case action11(Action11)
  case action12(Action12)
  case action20(Action20)
  case action21(Action21)
  case action22(Action22)
}

public typealias TypedAction00 = () -> Void                           // Void -> Void
public typealias TypedAction01<T: Codable> = () ->  T                 // Void -> T
public typealias TypedAction02<T: Codable> = () -> T?                 // Void -> T?

public typealias TypedAction10<T: Codable> = (T) -> Void              // T -> Void
public typealias TypedAction11<T: Codable, R: Codable> = (T) -> R     // T -> R
public typealias TypedAction12<T: Codable, R: Codable> = (T) -> R?    // T -> R?

public typealias TypedAction20<T: Codable> = (T?) -> Void             // T? -> Void
public typealias TypedAction21<T: Codable, R: Codable> = (T?) -> R    // T? -> R
public typealias TypedAction22<T: Codable, R: Codable> = (T?) -> R?   // T? -> R?

public protocol DataCoder {
  func encode<T: Codable>(_ value: T) throws -> Data
  func decode<T: Codable>(_ type: T.Type, from data: Data) throws -> T
}

public func convertToActionType(_ typedAction: @escaping TypedAction00) -> ActionType {
  return .action00(typedAction)
}

public func convertToActionType<T: Codable>(_ typedAction: @escaping TypedAction01<T>,
                                            coder: DataCoder) -> ActionType {
  let action: Action01 = {
    do {
      let data = try coder.encode(typedAction())
      return data
    } catch {
      assert(false, "Encoding error: \(error)")
      return Data()
    }
  }
  return .action01(action)
}

public func convertToActionType<T: Codable>(_ typedAction: @escaping TypedAction02<T>,
                                            coder: DataCoder) -> ActionType {
  let action: Action02 = {
    let data = try coder.encode(typedAction())
    return data
  }
  return .action02(action)
}

public func convertToActionType<T: Codable>(_ typedAction: @escaping TypedAction10<T>,
                                            coder: DataCoder) -> ActionType {
  let action: Action10 = { data in
    let value = try coder.decode(T.self, from: data)
    typedAction(value)
    
  }
  return .action10(action)
}

public func convertToActionType<T: Codable, R: Codable>(_ typedAction: @escaping TypedAction11<T, R>,
                                                        coder: DataCoder) -> ActionType {
  let action: Action11 = { data in
    let value = try coder.decode(T.self, from: data)
    let result = typedAction(value)
    let resultData = try coder.encode(result)
    return resultData
    
  }
  return .action11(action)
}

public func convertToActionType<T: Codable, R: Codable>(_ typedAction: @escaping TypedAction12<T, R>,
                                                        coder: DataCoder) -> ActionType {
  let action: Action12 = { data in
    let value = try coder.decode(T.self, from: data)
    let result = typedAction(value)
    let resultData = try coder.encode(result)
    return resultData
    
  }
  return .action12(action)
}

public func convertToActionType<T: Codable>(_ typedAction: @escaping TypedAction20<T>,
                                            coder: DataCoder) -> ActionType {
  let action: Action20 = { data in
    let value = try data.flatMap { try coder.decode(T.self, from: $0) }
    typedAction(value)
    
  }
  return .action20(action)
}

public func convertToActionType<T: Codable, R: Codable>(_ typedAction: @escaping TypedAction21<T, R>,
                                                        coder: DataCoder) -> ActionType {
  let action: Action21 = { data in
    let value = try data.flatMap { try coder.decode(T.self, from: $0) }
    let result = typedAction(value)
    let resultData = try coder.encode(result)
    return resultData
    
  }
  return .action21(action)
}

public func convertToActionType<T: Codable, R: Codable>(_ typedAction: @escaping TypedAction22<T, R>,
                                                        coder: DataCoder) -> ActionType {
  let action: Action22 = { data in
    let value = try data.flatMap { try coder.decode(T.self, from: $0) }
    let result = typedAction(value)
    let resultData = try coder.encode(result)
    return resultData
  }
  return .action22(action)
}


//class JSONDataCoder: DataCoder {
//    func encode<T>(_ value: T) throws -> Data where T : Codable {
//        return try JSONEncoder().encode(value)
//    }
//
//    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Codable {
//        return try JSONDecoder().decode(T.self, from: data)
//    }
//}

