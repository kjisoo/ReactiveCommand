//
//  ReactiveCommand.swift
//  Nimble
//
//  Created by A on 13/01/2019.
//

import RxSwift

public class ReactiveCommand<Input, Output>: CommandExecuter<Input> {
  public override var canExecute: Observable<Bool> {
    return self._canExecute
  }
  
  private let  _canExecute: Observable<Bool>
  private let _executingTrigger = PublishSubject<Input>()
  private let _resultObservable: Observable<Output>
  private let _disposeBag = DisposeBag()
  
  public init(execute: @escaping (Input) -> Output, canExecute: Observable<Bool> = .just(true)) {
    self._canExecute = canExecute
    self._resultObservable = self._executingTrigger
      .withLatestFrom(self._canExecute.filter { $0 }, resultSelector: { input, _ in input })
      .map(execute)
      .share()
    self._resultObservable.subscribe().disposed(by: _disposeBag)
  }
  
  public init<O>(execute: @escaping (Input) -> O, canExecute: Observable<Bool> = .just(true)) where O: ObservableType, Output == O.E {
    self._canExecute = canExecute
    self._resultObservable = self._executingTrigger
      .withLatestFrom(self._canExecute.filter { $0 }, resultSelector: { input, _ in input })
      .flatMapLatest(execute)
    self._resultObservable.subscribe().disposed(by: _disposeBag)
  }
  
  public override func execute(input: Input) {
    self._executingTrigger.onNext(input)
  }
}

extension ReactiveCommand: ObservableType {
  public typealias E = Output
  
  public func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, Output == O.E {
    return self._resultObservable.subscribe(observer)
  }
}

public extension ReactiveCommand {
  public static func combined(with executors: CommandExecuter<Input>...) -> ReactiveCommand<Input, Void> {
    let execute: (Input) -> Void = { input -> Void in
      executors.forEach { $0.execute(input: input) }
      return Void()
    }
    let canExecute = Observable
      .combineLatest(executors.map { $0.canExecute })
      .map { !$0.contains(false) }
    
    return ReactiveCommand<Input, Void>(execute: execute, canExecute: canExecute)
  }
  
  public func combined(with target: Observable<Input>) -> CommandExecuter<Void> {
    var lastInput: Input?
    target.subscribe(onNext: { input in
      lastInput = input
    }).disposed(by: self._disposeBag)
    
    return ReactiveCommand<Void, Void>(execute: { _ -> Void in
      guard let lastInput = lastInput else {
        return
      }
      
      self.execute(input: lastInput)
      return Void()
    }, canExecute: Observable.combineLatest(self.canExecute, target).map { $0.0 }).asCommandExecuter()
  }
}
