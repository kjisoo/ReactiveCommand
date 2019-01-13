#
# Be sure to run `pod lib lint ReactiveCommand.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ReactiveCommand'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ReactiveCommand.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
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
