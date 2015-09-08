module Umpire
  class NoRulesFound < StandardError
  end
end

require "umpire/version"
require "umpire/policy_missing_error"
require "umpire/auth_helper"
require "umpire/policy"
