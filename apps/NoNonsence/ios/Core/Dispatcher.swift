//
//  Dispatcher.swift
//  NoNonsence
//
//  Created by 叶永平 on 2024/7/9.
//

import Foundation
import MessagePack

public enum DispatchError: Error {
  case duplicateAction(name: String)
  case invalidAction(name: String)
  case invalidPrams(desc: String)
  case execError(error: Error)
}

public class Dispatcher {
  public static let shared = Dispatcher()
  private var lock = pthread_mutex_t()
  
  private var actions_ = [String: ActionType]()
  
  private init() {
    pthread_mutex_init(&lock, nil)
  }
  
  deinit {
    pthread_mutex_destroy(&lock)
  }
  
  public func register(action: ActionType, with name: String) -> Result<Void, DispatchError> {
    pthread_mutex_lock(&lock)
    defer { pthread_mutex_unlock(&lock) }
    guard actions_[name] == nil else {
      return .failure(.duplicateAction(name: name))
    }
    actions_[name] = action
    return .success(())
  }
  
  public func registerTyped(action: @escaping TypedAction00,
                             with name: String) -> Result<Void, DispatchError> {
    let action = convertToActionType(action)
    return register(action: action, with: name)
  }
  
  public func registerTyped<T: Codable>(action: @escaping TypedAction01<T>,
                                         with name: String) -> Result<Void, DispatchError> {
    let action = convertToActionType(action, coder: MsgpackCoder())
    return register(action: action, with: name)
  }
  
  public func registerTyped<T: Codable>(action: @escaping TypedAction02<T>,
                                         with name: String) -> Result<Void, DispatchError> {
    let action = convertToActionType(action, coder: MsgpackCoder())
    return register(action: action, with: name)
  }
  
  public func registerTyped<T: Codable>(action: @escaping TypedAction10<T>,
                                         with name: String) -> Result<Void, DispatchError> {
    let action = convertToActionType(action, coder: MsgpackCoder())
    return register(action: action, with: name)
  }
  
  public func registerTyped<T: Codable, R: Codable>(action: @escaping TypedAction11<T, R>,
                                                     with name: String) -> Result<Void, DispatchError> {
    let action = convertToActionType(action, coder: MsgpackCoder())
    return register(action: action, with: name)
  }
  
  public func registerTyped<T: Codable, R: Codable>(action: @escaping TypedAction12<T, R>,
                                                     with name: String) -> Result<Void, DispatchError> {
    let action = convertToActionType(action, coder: MsgpackCoder())
    return register(action: action, with: name)
  }
  
  public func registerTyped<T: Codable>(action: @escaping TypedAction20<T>,
                                         with name: String) -> Result<Void, DispatchError> {
    let action = convertToActionType(action, coder: MsgpackCoder())
    return register(action: action, with: name)
  }
  
  public func registerTyped<T: Codable, R: Codable>(action: @escaping TypedAction21<T, R>,
                                                     with name: String) -> Result<Void, DispatchError> {
    let action = convertToActionType(action, coder: MsgpackCoder())
    return register(action: action, with: name)
  }
  
  public func registerTyped<T: Codable, R: Codable>(action: @escaping TypedAction22<T, R>,
                                                     with name: String) -> Result<Void, DispatchError> {
    let action = convertToActionType(action, coder: MsgpackCoder())
    return register(action: action, with: name)
  }
  
  public func call(action name: String,
                    with params: Optional<Data>) -> Result<Optional<Data>, DispatchError> {
    pthread_mutex_lock(&lock)
    guard let action_ = actions_[name] else {
      pthread_mutex_unlock(&lock)
      return .failure(.invalidAction(name: name))
    }
    pthread_mutex_unlock(&lock)
    switch action_ {
    case .action00(let action):
      action()
      return .success(nil)
    case .action01(let action):
      do {
        return .success(try action())
      } catch {
        return .failure(.execError(error: error))
      }
    case .action02(let action):
      do {
        return .success(try action())
      } catch {
        return .failure(.execError(error: error))
      }
    case .action10(let action):
      guard let params else {
        let err = DispatchError.invalidPrams(desc: "action: \(name), a parameter is required, but get nil")
        return .failure(err)
      }
      do {
        try action(params)
        return .success(nil)
      }catch {
        return .failure(.execError(error: error))
      }
    case .action11(let action):
      guard let params else {
        let err = DispatchError.invalidPrams(desc: "action: \(name), a parameter is required, but get nil")
        return .failure(err)
      }
      do {
        return .success(try action(params))
      } catch {
        return .failure(.execError(error: error))
      }
    case .action12(let action):
      guard let params else {
        let err = DispatchError.invalidPrams(desc: "action: \(name), a parameter is required, but get nil")
        return .failure(err)
      }
      do {
        return .success(try action(params))
      } catch {
        return .failure(.execError(error: error))
      }
    case .action20(let action):
      do {
        try action(params)
        return .success(nil)
      } catch {
        return .failure(.execError(error: error))
      }
    case .action21(let action):
      guard let params else {
        let err = DispatchError.invalidPrams(desc: "action: \(name), a parameter is required, but get nil")
        return .failure(err)
      }
      do {
        return .success(try action(params))
      } catch {
        return .failure(.execError(error: error))
      }
    case .action22(let action):
      guard let params else {
        let err = DispatchError.invalidPrams(desc: "action: \(name), a parameter is required, but get nil")
        return .failure(err)
      }
      do {
        return .success(try action(params))
      } catch {
        return .failure(.execError(error: error))
      }
    }
  }
}

@_cdecl("CallDispatcherAction")
public func CallDispatcherAction(_ name: UnsafePointer<CChar>,
                                 _ params: UnsafePointer<UInt8>?,
                                 _ length: Int) -> DispatcherResult {
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
    return DispatcherResult(data: resultData,
                            length: Int32(resultLength),
                            errorCode: 0,
                            errorMessage: nil)
  case .failure(let error):
    let errorMessage = String(describing: error)
    return DispatcherResult(data: nil,
                            length: 0,
                            errorCode: 1,
                            errorMessage: strdup(errorMessage))
  }
}
