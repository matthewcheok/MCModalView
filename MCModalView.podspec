Pod::Spec.new do |s|
  s.name     = 'MCModalView'
  s.version  = '0.3'
  s.platform = :ios, '7.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'UIAlertView/UIActionSheet replacement supporting iPhone/iPad and device rotations.'
  s.homepage = 'https://github.com/matthewcheok/MCModalView'
  s.author   = { 'Matthew Cheok' => 'cheok.jz@gmail.com' }
  s.requires_arc = true
  s.source   = {
    :git => 'https://github.com/matthewcheok/MCModalView.git',
    :branch => 'master',
    :tag => s.version.to_s
  }
  s.source_files = 'MCModalView/*.{h,m}'
  s.public_header_files = 'MCModalView/*.h'
end
