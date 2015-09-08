# A very basic policy class. Extend other policies with this
# by providing a rules method which returns the valid actions
# based on the subject and object
#
# Usage
#
# with a single action:
# DrivingPolicy.allows?(driver).to(:drive, car)
#
# with multiple actions
# MemberPolicy.allows?(member).to([:join, :leave], club)
#
# without object
# SchoolPolicy.allows?(student).to(:cheat_on_exam)
#
module Umpire
  class Policy
  
    include AuthHelper

    def initialize subject
      @subject = subject
    end

    def self.allows? subject
      new subject
    end

    def to actions, object = nil
      @object = object
      @actions = *actions
      @actions.all? { |a| rules.include?(a) }
    end
  
    # overwrite me
    def rules
      raise NoRulesFound.new("Please implement `rules` in your policy object")
    end
  end

end
