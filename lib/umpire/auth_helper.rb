module Umpire
  module AuthHelper
    # Usage:
    #
    # without subject (assumes current_user)
    # can? :drive, car, using: DrivingPolicy
    #
    # with subject
    # can? user, :drive, car, using: DrivingPolicy
    #
    # multiple policies
    # can? :park, car, using: [DrivingPolicy, ParkingPolicy]
    #
    # without object
    # can? :cook_spaghetti, using: [KitchenPolicy]
    #
    # multiple actions
    # can? [:order, :drink], beer, using: BarPolicy
    #
    def can? *args
      options = args.extract_options!
      policies = *options[:using]
      raise "Policy class needs to be supplied: { using: SomePolicy }" unless policies.present?
    
      first_argument = args.shift
      if first_argument.is_a?(Symbol) || first_argument.is_a?(Array)
        subject = current_user
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
    
    def current_user
      current_user || {}
    end
  
  end

end
