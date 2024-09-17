require 'melisa'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should, :expect]
  end
  RSpec::Expectations.configuration.on_potential_false_positives = :nothing
end
