Pod::Spec.new do |s|
  s.name             = 'Pale'
  s.version          = '0.1.1'
  s.summary          = 'Addressable Moya provider.'

  s.description      = <<-DESC
  Pale is just a small addition on top of Moya to be able to use addressable providers,
  this is, providers with a configurable base URL.
                       DESC

  s.homepage         = 'https://github.com/OPENinput/Pale'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'José González' => 'jose.gonzalez@openinput.com' }
  s.source           = { :git => 'https://github.com/OPENinput/Pale.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version         = '5.0'
  s.default_subspec       = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'Pale/main/classes/core/**/*'
    core.dependency 'Moya', '14.0.0-alpha.1'
  end

  s.subspec 'RxSwift' do |rx|
    rx.source_files   = 'Pale/main/classes/rx/**/*'
    rx.dependency 'Pale/Core'
    rx.dependency 'Moya/RxSwift', '14.0.0-alpha.1'
    rx.dependency 'RxSwift', '~> 5.0'
  end
end
