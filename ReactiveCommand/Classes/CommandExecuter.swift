//
//  CommandExecuter.swift
//  ReactiveCommand
//
//  Created by A on 14/01/2019.
//

import Foundation

import RxSwift

public class CommandExecuter<Input>: CommandType {
  internal init() {}
  
  public var canExecute: Observable<Bool> {
    return .never()
  }
  
  public func execute(input: Input) {
    
  }
  
  func asCommandExecuter() -> CommandExecuter<Input> {
    return self
  }
}
