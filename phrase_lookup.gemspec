Gem::Specification.new do |s|
  s.name = 'phrase_lookup'
  s.version = '0.1.9'
  s.summary = 'Returns a list of matching phrases from plain text'
  s.authors = ['James Robertson']
  s.files = Dir['lib/phrase_lookup.rb']
  s.add_runtime_dependency('rxfhelper', '~> 1.0', '>=1.0.0')
  s.signing_key = '../privatekeys/phrase_lookup.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/phrase_lookup'
end
