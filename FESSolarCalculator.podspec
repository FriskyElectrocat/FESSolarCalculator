Pod::Spec.new do |s|
  s.name     = 'FESSolarCalculator'
  s.version  = '1.0'
  s.license  = 'MIT'
  s.summary  = 'Calculate sunrise, sunset, and twilight times for a given location and date.'
  s.homepage = 'https://github.com/iiiyu/FESSolarCalculator'
  s.author   = { 'danimal' => 'dan@danimal.org' }
  s.source   = { :git => 'https://github.com/danimal/FESSolarCalculator.git'}

  s.description = 'Calculate sunrise, sunset, and twilight times for a given location and date.'

  s.requires_arc = true
  s.framework    = 'CoreLocation'
  s.source_files = 'Source/*.{h,m}'
end
