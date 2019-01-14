//
//  CommandExecuterConvertibleType.swift
//  Pods-ReactiveCommand_Example
//
//  Created by A on 14/01/2019.
//

import Foundation

internal protocol CommandExecuterConvertibleType {
  associatedtype Input
  
  func asCommandExecuter() -> CommandExecuter<Input>
}
