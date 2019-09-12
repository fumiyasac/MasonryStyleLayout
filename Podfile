# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'MasonryStyleLayout' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MasonryStyleLayout
  pod 'Alamofire'
  pod 'PromiseKit'
  pod 'SwiftyJSON'
  pod 'SwiftyMarkdown'
  pod 'AlamofireImage'
  pod 'FontAwesome.swift'
  pod 'WaterfallLayout'
end

# MEMO: テストコードで利用する
target 'MasonryStyleLayoutTests' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MasonryStyleLayout
  pod 'PromiseKit'
  pod 'SwiftyJSON'
end

# MEMO: 一部ライブラリのバージョンを4.2で固定する
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if ['WaterfallLayout','WaterfallLayout'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
      end
    end
  end
end
