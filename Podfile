# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

target 'smartsell' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  
  # Pods for licsuperagent
  # pod 'Charts'
  pod 'Core', :git => 'git@gitlab.com:enparadigm_superagent/smartsell-ios-core.git'
  pod 'Poster', :git => 'git@gitlab.com:enparadigm_superagent/smartsell-ios-posters.git'
  pod 'pdf', :git => 'git@gitlab.com:enparadigm_superagent/smartsell-ios-pdf.git'
  pod 'Video', :git => 'git@gitlab.com:enparadigm_superagent/smartsell-ios-video.git'
  pod 'Directory', :git => 'git@gitlab.com:enparadigm_superagent/smartsell-ios-directory.git'
  pod 'mfadvisor', :git => 'git@gitlab.com:enparadigm_superagent/smartsell-ios-mfadvisor.git'
  pod 'news', :git => 'git@gitlab.com:enparadigm_superagent/smartsell-ios-news.git'
  pod 'quiz', :git => 'git@gitlab.com:enparadigm_superagent/smartsell-ios-quiz.git'
  pod 'apptentive-ios'

  pod 'XLPagerTabStrip', '~> 7.0'
  #pod 'Kingfisher', '~> 3.0'

  target 'smartsellTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'smartsellUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
