Gem::Specification.new do |s|
  s.name = 'phrase_lookup'
  s.version = '0.2.0'
  s.summary = 'Returns a list of matching phrases from plain text'
  s.authors = ['James Robertson']
  s.files = Dir['lib/phrase_lookup.rb']
  s.add_runtime_dependency('rxfreadwrite', '~> 0.2', '>=0.2.4')
  s.signing_key = '../privatekeys/phrase_lookup.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/phrase_lookup'
end
