#
# Be sure to run `pod lib lint ReactiveCommand.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ReactiveCommand'
  s.version          = '1.0.0'
  s.summary          = 'Command available in MVVM.'

  s.description      = <<-DESC
You can use the ReactiveCommand to distinguish commands and properties in a ViewModel.
Command executes the closure statement or switches Observable.
Command can be created by combining multiple commands.
Command can be used by binding to Cocoa Component.
                       DESC

  s.homepage         = 'https://github.com/kjisoo/ReactiveCommand'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kjisoo' => 'kim@jisoo.net' }
  s.source           = { :git => 'https://github.com/kjisoo/ReactiveCommand.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2'

  s.source_files = 'ReactiveCommand/Classes/**/*'
  
  s.dependency 'RxSwift', '~> 4.0'
  s.dependency 'RxCocoa', '~> 4.0'
end
