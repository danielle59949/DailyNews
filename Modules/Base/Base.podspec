Pod::Spec.new do |s|
  s.name             = 'Base'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Core.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/danielle59949/Base'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Le' => 'danielle@savvycomsoftware.com' }
  s.source           = { :git => 'https://github.com/danielle59949/Base.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'Base/Classes/**/*'

end
