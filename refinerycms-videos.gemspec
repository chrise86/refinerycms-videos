# Encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)
require "refinery/videos/version"

Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = "refinerycms-videos"
  s.version       = Refinery::Videos::Version.to_s
  s.authors       = ["Jamie Winsor", "Chris Reister"]
  s.email         = ["jamie@vialstudios.com", "creister@enmasse.com"]
  s.homepage      = "https://github.com/enmasse-entertainment/refinerycms-videos"
  s.summary       = 'Videos engine for Refinery CMS'
  s.description   = 'Ruby on Rails Videos engine for Refinery CMS'
  s.require_paths = %w(lib)
  
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.add_dependency 'refinerycms-core'#, '~> 2.0.6'
  s.add_dependency 'refinerycms-authentication'#, '~> 2.0.6'
  s.add_dependency 'dragonfly-ffmpeg', '~> 0.1.6'
  #s.add_dependency 'resque', '~> 1.17.1' # updated to 1.18.6
  s.add_dependency 'resque', '~> 1.18.6'
  
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "refinerycms-testing"#, '~> 2.0.6'
end
