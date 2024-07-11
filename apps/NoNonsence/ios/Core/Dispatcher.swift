//
//  Dispatcher.swift
//  NoNonsence
//
//  Created by 叶永平 on 2024/7/9.
//

import Foundation
import MessagePack

public typealias Action = (Optional<Data>) -> Optional<Data>
public typealias TypedAction<P, R> = (Optional<P>) -> Optional<R> where P: Codable, R: Codable

public enum DispatchError: Error {
  case duplicateAction(name: String)
  case invalidAction(name: String)
}

/*
 TODO: 1. 添加参数和返回值的可选校验
 */

public class Dispatcher {
  public static let shared = Dispatcher()
  private var actions = [String: Action]()
  private var lock = pthread_mutex_t()
  
  private init() {
    pthread_mutex_init(&lock, nil)
  }
  
  deinit {
    pthread_mutex_destroy(&lock)
  }
  
  public func resisterTyped<P: Codable, R:Codable>(action: @escaping TypedAction<P, R>,
                                              with name: String) -> Result<Void, DispatchError> {
    let _action = { (origin: Data?) -> Data? in
      var res: R? = nil
      if let origin {
        let decoder = MessagePackDecoder()
        do {
          let deserializedMessage = try decoder.decode(P.self, from: origin)
          res = action(deserializedMessage)
        } catch {
          // TODO: 异常处理
          print("Deserialization error: \(error)")
          return nil
        }
      } else {
        res = action(nil)
      }
      if let res {
        let encoder = MessagePackEncoder()
        do {
          let serializedMessage = try encoder.encode(res)
          return serializedMessage
        } catch {
          // TODO: 异常处理
          print("Serialization error: \(error)")
          return nil
        }
      }
      return nil
    }
    return register(action: _action, with: name)
  }
  
  public func register(action: @escaping Action, with name: String) -> Result<Void, DispatchError> {
    pthread_mutex_lock(&lock)
    defer { pthread_mutex_unlock(&lock) }
    guard actions[name] == nil else {
      return .failure(.duplicateAction(name: name))
    }
    actions[name] = action
    return .success(())
  }
  
  func call(action name: String, with params: Optional<Data>) -> Result<Optional<Data>, DispatchError> {
    pthread_mutex_lock(&lock)
    guard let action = actions[name] else {
      pthread_mutex_unlock(&lock)
      return .failure(.invalidAction(name: name))
    }
    pthread_mutex_unlock(&lock)
    return .success(action(params))
  }
  
}

@_cdecl("CallDispatcherAction")
public func CallDispatcherAction(_ name: UnsafePointer<CChar>, _ params: UnsafePointer<UInt8>?, _ length: Int) -> DispatcherResult {
  let actionName = String(cString: name)
  let data: Data?
  if let params = params {
    data = Data(bytes: params, count: length)
  } else {
    data = nil
  }
  
  let result = Dispatcher.shared.call(action: actionName, with: data)
  switch result {
  case .success(let data):
    var resultData: UnsafeMutablePointer<UInt8>? = nil
    var resultLength = 0
    if let data {
      resultLength = data.count
      resultData = UnsafeMutablePointer<UInt8>.allocate(capacity: resultLength)
      data.copyBytes(to: resultData!, count: resultLength)
    }
    return DispatcherResult(data: resultData, length: Int32(resultLength), errorCode: 0, errorMessage: nil)
  case .failure(let error):
    let errorMessage = String(describing: error)
    return DispatcherResult(data: nil, length: 0, errorCode: 1, errorMessage: strdup(errorMessage))
  }
}
