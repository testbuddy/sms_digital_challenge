lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sms_digital_challenge/version'

Gem::Specification.new do |spec|
  spec.name          = 'sms_digital_challenge'
  spec.version       = SmsDigitalChallenge::VERSION
  spec.authors       = ['Alexander Drangmeister']
  spec.email         = ['csnk2@hotmail.de']

  spec.summary       = 'SMS digital GmbH challenge'
  spec.homepage      = 'https://github.com/testbuddy/sms_digital_challenge'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set
  # the 'allowed_push_host' to allow pushing to a single host or
  # delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = spec.homepage
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  # rubocop:disable Metrics/LineLength
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  # rubocop:enable Metrics/LineLength
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'flickr_fu', '~> 0.3.4'
  spec.add_development_dependency 'mini_magick', '~> 4.9.3'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'parallel', '~> 1.17.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.67.2'
  spec.add_development_dependency 'slop', '~> 4.6.2'
end
