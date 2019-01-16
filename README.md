# ReactiveCommand

[![CI Status](https://img.shields.io/travis/kjisoo/ReactiveCommand.svg?style=flat)](https://travis-ci.org/kjisoo/ReactiveCommand)
[![Version](https://img.shields.io/cocoapods/v/ReactiveCommand.svg?style=flat)](https://cocoapods.org/pods/ReactiveCommand)
[![License](https://img.shields.io/cocoapods/l/ReactiveCommand.svg?style=flat)](https://cocoapods.org/pods/ReactiveCommand)
[![Platform](https://img.shields.io/cocoapods/p/ReactiveCommand.svg?style=flat)](https://cocoapods.org/pods/ReactiveCommand)

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.
### Creation ReactiveCommand
```swift
// use closure
let command = ReactiveCommand<InputType, OutputType>(execute: (InputType) -> OutputType, canExecute: Observable<Bool>)

// transform observable
let loadMoreCommand = ReactiveCommand<Int, Post>(execute: postService.load)

// combined command
// The Input Type must be the same.
// OutputType does not matter.
let removeA = ReactiveCommand<Void, Void>(execute...)
let removeB = ReactiveCommand<Void, Void>(execute...)
let removeC = ReactiveCommand<Void, Void>(execute...)
let removeAllCommand = ReactiveCommand.combined(with: removeA.asCommandExecuter(), removeB.asCommandExecuter(), removeC.asCommandExecuter())
```
### Subscribe
```swift
let command = ReactiveCommand<Input, Output>.init(...)
command.subscribe(onNext: { Output in
    // something
})
```
### Binding
```swift
let saveCommand = ReactiveCommand<Void, Output).init(...)
var saveButton: UIButton
saveButton.bind(to: saveCommand.asCommandExecuter()).disposed(by: disposeBag)

// Binding with TextField like passcode
let passCommand = ReactiveCommand<String, Void>(execute: { (code) in
    // code
})
let combinedEexecutor = passCommand.combined(with: textField.rx.text.orEmpty.asObservable())
doneButton.bind(to: combinedEexecutor).disposed(by: disposeBag)
```

## Requirements
 - swift 4.2

## Installation

ReactiveCommand is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ReactiveCommand'
```

## Author

kjisoo, kim@jisoo.net

## License

ReactiveCommand is available under the MIT license. See the LICENSE file for more info.
