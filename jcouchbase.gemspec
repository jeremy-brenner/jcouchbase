Gem::Specification.new do |s|
  s.name              = 'jcouchbase'
  s.version           = '0.1.1'
  s.date              = '2012-08-28'
  s.platform          = Gem::Platform::RUBY
  s.authors           = ["Jeremy J Brenner"]
  s.email             = ["jeremyjbrenner@gmail.com"]
  s.summary           = "Thin ruby wrapper around Couchbase Java Driver; for JRuby only"
  s.description       = %q{Thin jruby wrapper around Couchbase Java Driver}
  s.homepage          = 'http://github.com/jeremy-brenner/jcouchbase'

  # = MANIFEST =
  s.files = %w[
    README.md
  ]
  # = MANIFEST =

  s.add_dependency 'require_all',                 '~> 1.2'
  
end
