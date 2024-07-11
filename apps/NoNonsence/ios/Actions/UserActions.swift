//
//  UserAction.swift
//  NoNonsence
//
//  Created by 叶永平 on 2024/7/10.
//

import Foundation


public class UserActions: NSObject {
  @objc public static func registerGetCurrentUserAction() {
    switch Dispatcher.shared.registerTyped(action: getCurrentUser, with: "getCurrentUser") {
    case .success():
      print("register typed getCurrentUser success")
    case .failure(let error):
      print("register typed getCurrentUser error: \(error)")
    }
  }
}

public struct PlaceHolder: Codable {}

public struct User: Codable {
  public let firstName: String
  public let lastName: String
}

func getCurrentUser() -> User? {
  return User(firstName: "尼古拉斯", lastName: "凯奇")
}
