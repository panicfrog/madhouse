require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name            = "NativeMadCore"
  s.version         = package["version"]
  s.summary         = package["description"]
  s.description     = package["description"]
  s.homepage        = package["repository"]
  s.license         = package["license"]
  s.platforms       = { :ios => "12.4" }
  s.author          = package["author"]
  s.source          = { :git => package["repository"], :tag => "#{s.version}" }

  # Include source files from ios and generated codegen directories
  # s.source_files = 'ios/**/*.{h,m,mm,swift}', 'codegen/build/generated/ios/**/*.{h,m,mm,swift}'
  s.source_files = 'ios/**/*.{h,m,mm,swift}'
  
  # React Native dependencies
  # s.dependency 'React-Core'
  # s.dependency 'ReactCommon'
  # s.dependency 'React-cxxreact'
  # s.dependency 'React-jsi'
  # s.dependency 'React-jsiexecutor'
  # s.dependency 'React-jsinspector'
  # s.dependency 'RCTRequired'
  # s.dependency 'RCTTypeSafety'
  # s.dependency 'React-RCTFabric'

  s.pod_target_xcconfig = {
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
    'CLANG_CXX_LIBRARY' => 'libc++'
  }
  # install_modules_dependencies(s)
end
