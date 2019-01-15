//
//  UITableView+ReactiveCommand.swift
//  ReactiveCommand
//
//  Created by A on 16/01/2019.
//

import UIKit

import RxSwift
import RxCocoa

public extension UITableView {
  public func bind(to command: CommandExecuter<IndexPath>) -> Disposable {
    return Disposables.create(
      [
        self.rx.itemSelected
          .subscribe(onNext: command.execute)
      ]
    )
  }
  
  public func bind(to command: CommandExecuter<(Int, Int)>) -> Disposable {
    return Disposables.create(
      [
        self.rx.itemSelected
          .map { ($0.section, $0.row) }
          .subscribe(onNext: command.execute)
      ]
    )
  }
}
