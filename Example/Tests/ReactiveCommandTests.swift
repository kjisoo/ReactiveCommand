//
//  ReactiveCommandTests.swift
//  ReactiveCommand_Tests
//
//  Created by A on 13/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import RxSwift

@testable import ReactiveCommand

class ReactiveCommandTests: XCTestCase {
  func testDefaultCanExecuteIsTrue() {
    // Arrange
    let expectation = self.expectation(description: "Expect to be executed.")
    let reactiveCommand = ReactiveCommand<Void, Void>(execute: { _ -> Void in
      expectation.fulfill()
      return Void()
    })
    
    // Act
    reactiveCommand.execute(input: Void())
    
    // Assert
    self.waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testExecuteFourTimes() {
    // Arrange
    let expectation = self.expectation(description: "Expect to be executed four times.")
    expectation.expectedFulfillmentCount = 4
    let reactiveCommand = ReactiveCommand<Void, Void>(execute: { _ -> Void in
      expectation.fulfill()
      return Void()
    })
    
    // Act
    reactiveCommand.execute(input: Void())
    reactiveCommand.execute(input: Void())
    reactiveCommand.execute(input: Void())
    reactiveCommand.execute(input: Void())
    
    // Assert
    self.waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testNeverExecuteWhenCanExecuteFalse() {
    // Arrange
    let expectation = self.expectation(description: "Expect a not to be executed.")
    expectation.isInverted = true
    let reactiveCommand = ReactiveCommand<Void, Void>(execute: { _ -> Void in
      expectation.fulfill()
      return Void()
    }, canExecute: .just(false))
    
    // Act
    reactiveCommand.execute(input: Void())
    
    // Assert
    self.waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testNotExecutedWhenCanExecuteChanged() {
    // Arrange
    let canExecute = BehaviorSubject(value: false)
    let expectation = self.expectation(description: "Expect a not to be executed.")
    expectation.isInverted = true
    let reactiveCommand = ReactiveCommand<Void, Void>(execute: { _ -> Void in
      expectation.fulfill()
      return Void()
    }, canExecute: canExecute)
    
    // Act
    canExecute.onNext(true)
    canExecute.onNext(false)
    canExecute.onNext(true)
    
    // Assert
    self.waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testSubscribe() {
    // Arrange
    let expectation = self.expectation(description: "Expect to be executed.")
    let reactiveCommand = ReactiveCommand<Void, Void>(execute: { _ -> Void in
      return Void()
    })
    _ = reactiveCommand.subscribe(onNext: { _ in
      expectation.fulfill()
    })
    
    // Act
    reactiveCommand.execute(input: Void())
    
    // Assert
    self.waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testWithNotEmittedTarget() {
    // Arragne
    let expectation = self.expectation(description: "Expect a not to be executed.")
    let reactiveCommand = ReactiveCommand<Int, Void>(execute: { input -> Void in
      expectation.fulfill()
      return Void()
    })
    let voidCommandExecuter = reactiveCommand.combined(with: .never())
    expectation.isInverted = true
    
    // Act
    voidCommandExecuter.execute(input: Void())
    
    // Assert
    self.waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testWithTarget() {
    // Arragne
    let expectation = self.expectation(description: "Expect to be executed.")
    var receivedInput = 0
    let reactiveCommand = ReactiveCommand<Int, Void>(execute: { input -> Void in
      receivedInput = input
      expectation.fulfill()
      return Void()
    })
    let voidCommandExecuter = reactiveCommand.combined(with: .just(123))
    
    // Act
    voidCommandExecuter.execute(input: Void())
    
    // Assert
    self.waitForExpectations(timeout: 1, handler: nil)
    XCTAssertEqual(receivedInput, 123)
  }
  
  func testExecuteAsObservable() {
    // Arrange
    let expectation = self.expectation(description: "Expect to be executed.")
    let transform: () -> Observable<Int> = {
      expectation.fulfill()
      return .just(0)
    }
    let reactiveCommand = ReactiveCommand<Void, Int>(execute: transform)
    
    // Act
    reactiveCommand.execute(input: Void())
    
    // Assert
    self.waitForExpectations(timeout: 1, handler: nil)
  }
    
  func testCombinedCommandCreatedWithUnexecutableCommands() {
    // Arrange
    let expectation = self.expectation(description: "Expect a not to be executed.")
    let reactiveCommand = ReactiveCommand<Int, Void>(execute: { input -> Void in
      expectation.fulfill()
      return Void()
    }, canExecute: Observable<Bool>.just(false))
    let combinedCommand = ReactiveCommand<Int, Void>.combined(with: reactiveCommand.asCommandExecuter())
    expectation.isInverted = true
    
    // Act
    combinedCommand.execute(input: 0)
    
    // Assert
    self.waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testCombinedCommandCreatedWithExecutableCommands() {
    // Arrange
    let expectation = self.expectation(description: "Expect a not to be executed.")
    let reactiveCommand1 = ReactiveCommand<Int, Void>(execute: { input -> Void in
      expectation.fulfill()
      return Void()
    })
    let reactiveCommand2 = ReactiveCommand<Int, Void>(execute: { input -> Void in
      expectation.fulfill()
      return Void()
    })
    let combinedCommand = ReactiveCommand<Int, Void>.combined(with: reactiveCommand1.asCommandExecuter(), reactiveCommand2.asCommandExecuter())
    expectation.expectedFulfillmentCount = 2
    
    // Act
    combinedCommand.execute(input: 0)
    
    // Assert
    self.waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testCombinedCommandCreatedWithLazyExecutableCommands() {
    // Arrange
    let expectation = self.expectation(description: "Expect a not to be executed.")
    let canExecute = PublishSubject<Bool>()
    let reactiveCommand1 = ReactiveCommand<Int, Void>(execute: { input -> Void in
      expectation.fulfill()
      return Void()
    })
    let reactiveCommand2 = ReactiveCommand<Int, Void>(execute: { input -> Void in
      expectation.fulfill()
      return Void()
    }, canExecute: canExecute)
    let combinedCommand = ReactiveCommand<Int, Void>.combined(with: reactiveCommand1.asCommandExecuter(), reactiveCommand2.asCommandExecuter())
    expectation.expectedFulfillmentCount = 2
    canExecute.onNext(true)
    
    // Act
    combinedCommand.execute(input: 0)
    
    // Assert
    self.waitForExpectations(timeout: 1, handler: nil)
  }
}
