//
//  ReactiveCommand.swift
//  Nimble
//
//  Created by A on 13/01/2019.
//

import RxSwift

public class ReactiveCommand<Input, Output>: ObservableType {
  public typealias E = Output
  
  public let canExecute: Observable<Bool>
  
  private let _executingTrigger = PublishSubject<Input>()
  private let _resultObservable: Observable<Output>
  private let _resultDisposable: Disposable
  
  public init(execute: @escaping (Input) -> Output, canExecute: Observable<Bool> = .just(true)) {
    self.canExecute = canExecute
    self._resultObservable = self._executingTrigger
      .withLatestFrom(self.canExecute.filter { $0 }, resultSelector: { input, _ in input })
      .map(execute)
      .share()
    self._resultDisposable = self._resultObservable.subscribe()
  }
  
  public func execute(input: Input) {
    self._executingTrigger.onNext(input)
  }
  
  public func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, Output == O.E {
    return self._resultObservable.subscribe(observer)
  }
  
  deinit {
    self._resultDisposable.dispose()
  }
}
