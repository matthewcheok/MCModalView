Pod::Spec.new do |s|
  s.name     = 'MCAlertView'
  s.version  = '0.2'
  s.platform = :ios, '7.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'UIAlertView replacement supporting iPhone/iPad and device rotations.'
  s.homepage = 'https://github.com/matthewcheok/MCAlertView'
  s.author   = { 'Matthew Cheok' => 'cheok.jz@gmail.com' }
  s.requires_arc = true
  s.source   = {
    :git => 'https://github.com/matthewcheok/MCAlertView.git',
    :branch => 'master',
    :tag => s.version.to_s
  }
  s.source_files = 'MCAlertView/*.{h,m}'
  s.public_header_files = 'MCAlertView/*.h'
end
