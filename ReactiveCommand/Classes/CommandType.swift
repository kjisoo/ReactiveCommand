//
//  CommandType.swift
//  ReactiveCommand
//
//  Created by A on 14/01/2019.
//

import Foundation

import RxSwift

protocol CommandType: CommandExecuterConvertibleType {
  var canExecute: Observable<Bool> { get }
  
  func execute(input: Input)
}
