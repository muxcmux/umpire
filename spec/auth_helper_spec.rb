require 'spec_helper'

class TestHelper
  include Umpire::AuthHelper
end

class TestHelperWithUser
  include Umpire::AuthHelper
  attr_accessor :player
  def current_user
    @player ||= Player.new points: 1, has_permanent_ban: false
  end
end

RSpec.describe Umpire::AuthHelper do
  
  let!(:helper) { TestHelper.new }
  let!(:user_helper) { TestHelperWithUser.new }
  let!(:djok) { Player.new name: 'Novak Djokovic', points: 14_000, has_permanent_ban: false }
  let!(:kyrgios) { Player.new name: 'Nick Kyrgios', points: 1_500, has_permanent_ban: true }
  let!(:coke) { Beverage.new false }
  let!(:gin_tonic) { Beverage.new true }
  
  it 'raises error if policy is missing' do
    expect {helper.can? :play_tennis}.to raise_error(Umpire::PolicyMissingError)
  end
  
  context 'without object' do
    it 'uses empty hash for subject when current_user is unavailable' do
      expect(TennisRules).to receive(:allows?).with({}).and_return(TennisRules.new({}))
      expect_any_instance_of(TennisRules).to receive(:to).with(:play_tennis, nil)
      
      helper.can? :play_tennis, using: TennisRules
    end
  
    it 'uses current_user when available for subject' do
      player = user_helper.current_user
      expect(TennisRules).to receive(:allows?).with(player).and_return(TennisRules.new(player))
      expect_any_instance_of(TennisRules).to receive(:to).with(:play_tennis, nil)
      
      user_helper.can? :play_tennis, using: TennisRules
    end
    
    it 'uses the subject if passed as first argument' do
      expect(TennisRules).to receive(:allows?).with(djok).and_return(TennisRules.new(djok))
      expect_any_instance_of(TennisRules).to receive(:to).with(:play_tennis, nil)
      
      helper.can? djok, :play_tennis, using: TennisRules
    end
  end
  
  context 'with object' do
    it 'uses the object passed' do
      expect(TennisRules).to receive(:allows?).with(djok).and_return(TennisRules.new(djok))
      expect_any_instance_of(TennisRules).to receive(:to).with(:have_a_drink, coke)
      
      helper.can? djok, :have_a_drink, coke, using: TennisRules
    end
  end
  
  context 'with multiple policies' do
    it 'checks second policy if first policy returns true' do
      expect(TennisRules).to receive(:allows?).with(djok).and_return(TennisRules.new(djok))
      expect_any_instance_of(TennisRules).to receive(:to).with(:play_tennis, gin_tonic).and_return(true)
      
      expect(DrinkingRules).to receive(:allows?).with(djok).and_return(DrinkingRules.new(djok))
      expect_any_instance_of(DrinkingRules).to receive(:to).with(:play_tennis, gin_tonic)
      
      helper.can? djok, :play_tennis, gin_tonic, using: [TennisRules, DrinkingRules]
    end
    
    it 'returns false after first policy returns false' do
      expect(TennisRules).to receive(:allows?).with(djok).and_return(TennisRules.new(djok))
      expect_any_instance_of(TennisRules).to receive(:to).with(:play_tennis, gin_tonic).and_return(false)
      
      expect(DrinkingRules).to_not receive(:allows?).with(djok)
      expect_any_instance_of(DrinkingRules).to_not receive(:to).with(:play_tennis, gin_tonic)
      
      helper.can? djok, :play_tennis, gin_tonic, using: [TennisRules, DrinkingRules]
    end
    
  end
end
