# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
inhibit_all_warnings!

def shared_pods
  pod 'RxSwift', '~> 5.0.0'
  pod 'RxCocoa', '~> 5.0.0'
  pod 'RxDataSources', '~> 4.0.1'
  pod 'Action', '~> 4.0.0'
  pod 'NSObject+Rx', '~> 5.0.0'
  pod 'RealmSwift', '~> 3.17.1'
  pod 'RxRealm', '~> 1.0.0'
  pod 'PieCharts', '~> 0.0.7'
  pod 'RxGesture', '~> 3.0.0'
  pod 'Firebase/Analytics'
  pod 'SwiftDate', '~> 6.0.3'
end

target 'NoExpense' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NoExpense
  shared_pods
  
  target 'NoExpenseTests' do
    inherit! :search_paths
    # Pods for testing
    
  end

end
