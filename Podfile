platform :ios, '14.1'

target 'Onecalios' do
  use_frameworks!

  # SwiftUI, iOS 14.0 or later

  # Architecture
  pod 'ReactorKit'

  # Rx
  pod 'RxSwift', '~> 6.2'
  pod 'RxCocoa'
  pod 'RxAlamofire'
  pod 'RxViewController'
  #pod 'RxLifeCycle'
  pod 'RxLifeCycle', :git => 'https://github.com/neoroman/RxLifeCycle.git', :branch => 'master'
  #pod 'RxDataSources'
  #pod 'RxOptional'

  # UI
  #pod 'SnapKit'
  #pod 'ManualLayout'

  # Misc.
  #pod 'Then'
  #pod 'ReusableKit'
  #pod 'CGFloatLiteral'
  #pod 'URLNavigator'

  # Testing
  #target 'OnecaliosTests' do
  #  pod 'RxTest'
  #  pod 'RxExpect'
  #  pod 'RxOptional'
  #end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.1'
    end
  end
end
