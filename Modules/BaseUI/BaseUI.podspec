Pod::Spec.new do |s|
  s.name             = 'BaseUI'
  s.version          = '0.1.0'
  s.summary          = 'A short description of CoreUI.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/danielle59949/CoreUI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Le' => 'danielle@savvycomsoftware.com' }
  s.source           = { :git => 'https://github.com/danielle59949/BaseUI.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'BaseUI/Classes/**/*'

  s.dependency 'Base'
end
