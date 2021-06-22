Pod::Spec.new do |s|
  s.name = 'AutoSelfieLibChallenge'
  s.version = '0.1.0'
  s.summary = 'Auto Selfie - iOS Library Coding Challenge'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage = 'https://github.com/easytarget2000/AutoSelfieIOSLibChallenge'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'easytarget2000' => 'michel@easy-target.eu' }
  s.source = { :git => 'https://github.com/easytarget2000/AutoSelfieIOSLibChallenge.git', :tag => s.version.to_s }

  s.ios.deployment_target = '14.5'
  s.swift_versions = '5'

  s.source_files = 'AutoSelfieLibChallenge/Classes/**/*'
  
  s.frameworks = 'AVFoundation', 'Foundation'#, 'MLKitPoseDetectionCommon'
  # s.dependency 'GoogleMLKit/PoseDetectionAccurate', '2.0.0'
  s.static_framework = true

end
