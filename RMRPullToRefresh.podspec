Pod::Spec.new do |spec|
  spec.name         = "RMRPullToRefresh"
  spec.version      = "0.1"
  spec.platform     = :ios, "8.0"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.summary      = "A pull to refresh control for UIScrollView (UITableView and UICollectionView)"
  spec.homepage     = "http://redmadrobot.com/"
  spec.author       = "Ilya Merkulov"
  spec.source       = { :git => :"https://github.com/imerkulov/RMRPullToRefresh.git", :tag => "v0.1" }
  spec.source_files = "Classes/*.{swift}", "Classes/Default/*.{swift}"
end