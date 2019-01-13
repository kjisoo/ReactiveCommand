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
}
