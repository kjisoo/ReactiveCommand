//
//  UIButton+ReactiveCommand.swift
//  ReactiveCommand
//
//  Created by A on 15/01/2019.
//

import UIKit

import RxSwift
import RxCocoa

public extension UIButton {
  public func bind(to command: CommandExecuter<Void>, controlEvents: UIControl.Event = [.touchUpInside]) -> Disposable {
    return Disposables.create(
      command.canExecute
        .bind(to: self.rx.isEnabled),
      
      self.rx.controlEvent(controlEvents)
        .subscribe(onNext: command.execute)
    )
  }
}
