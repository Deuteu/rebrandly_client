Gem::Specification.new do |s|
  s.name        = 'rebrandly_client'
  s.version     = '0.0.1'
  s.date        = '2018-06-30'
  s.summary     = 'Rebrandly API client'
  s.description = 'A simple ruby client to connect to the Rebrandly API'
  s.authors     = ['Guillaume Dt']
  s.email       = 'Deuteu@users.noreply.github.com'
  s.homepage    = 'https://github.com/Deuteu/rebrandly_client'
  s.license     = 'Apache License 2.0'
  s.files       = %w(
                    lib/rebrandly_client.rb
                    lib/rebrandly/configuration.rb
                    lib/rebrandly/error.rb
                  )
  s.add_runtime_dependency 'httparty', '~> 0.16.2'
end