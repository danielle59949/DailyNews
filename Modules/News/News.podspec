Pod::Spec.new do |s|
  s.name             = 'News'
  s.version          = '0.1.0'
  s.summary          = 'A short description of News.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/danielle59949/News'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Le' => 'danielle@savvycomsoftware.com' }
  s.source           = { :git => 'https://github.com/danielle59949/News.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'News/**/**/*.{xib,swift,h,m}'
  s.resources = 'News/Assets/*.{png,json,xcassets}'
  s.resource_bundles = {
      'News' => ['News/Assets/**/*.{png,xcassets,json,txt,storyboard,xib,xcdatamodeld,strings}']
  }
  
  s.dependency 'Helper'
  s.dependency 'BaseUI'
  s.dependency 'Base'
  s.dependency 'Reusable'
  s.dependency 'SkeletonView'
  s.dependency 'Reusable'
  s.dependency 'Kingfisher', '~> 7.0'
end
