require 'umpire'
require 'tennis_rules'
require 'drinking_rules'
require 'player'
require 'beverage'

RSpec.configure do |config|
  
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  
  config.order = :random
  Kernel.srand config.seed
  
  config.tty = true
  
  config.color = true
  
  config.formatter = :documentation
  
  config.include Umpire::AuthHelper

end
