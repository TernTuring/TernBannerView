
Pod::Spec.new do |s|
	s.name			= 'TernBannerView'
	s.version		= '0.0.1'
	s.summary		= 'A clean and simple banner for iPhone and iPad'
	s.homepage		= 'https://github.com/TernTuring/TernBannerView'
	s.author		= { 'TernTuring' => 'ternturing@aol.com' }
	s.license 		= 'MIT'
	s.platform		= :ios, '9.0'
	s.requires_arc	= true
	s.source		= { :git => 'https://github.com/TernTuring/TernBannerView.git', :tag => s.version.to_s }
	s.source_files	= 'TernBannerView/*.{h,m}'
end