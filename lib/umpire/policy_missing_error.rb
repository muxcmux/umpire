module Umpire
  class PolicyMissingError < StandardError
    def message
      "Policy class needs to be supplied: { using: SomePolicy }"
    end
  end
end
