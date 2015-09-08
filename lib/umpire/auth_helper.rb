module Umpire
  module AuthHelper
    # Usage:
    #
    # with subject
    # can? user, :drive, car, using: HighwayCode
    #
    # without subject (assumes current_user if available)
    # can? :drive, car, using: HighwayCode
    #
    # multiple policies
    # can? :park, car, using: [HighwayCode, ParkingRules]
    #
    # without object
    # can? :cook_spaghetti, using: [KitchenPolicy]
    #
    # multiple actions
    # can? [:order, :drink], beer, using: BarPolicy
    #
    def can? *args
      options = args.last.is_a?(Hash) ? args.pop : {}
      policies = *options[:using]
      raise PolicyMissingError.new if policies.empty?
    
      first_argument = args.shift
      if first_argument.is_a?(Symbol) || first_argument.is_a?(Array)
        subject = defined?(current_user) ? current_user : {}
        actions = first_argument
      else
        subject = first_argument
        actions = args.shift
      end
    
      next_argument = args.shift
      object = next_argument.is_a?(Hash) ? nil : next_argument
    
      policies.each do |policy|
        return false unless policy.allows?(subject).to(actions, object)
      end
    
      true
    end
    
  
  end

end
