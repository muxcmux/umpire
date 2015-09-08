require 'spec_helper'

RSpec.describe Umpire::Policy do
  
  it 'returns new object from factory' do
    policy = Umpire::Policy.allows?({})
    expect(policy).to be_a(Umpire::Policy)
  end
  
  it 'raises exception if rules left unoverriden' do
    policy = Umpire::Policy.new({})
    expect { policy.to(:play_tennis) }.to raise_error(Umpire::NoRulesFound)
  end
  
  it 'sets object and actions when to is called' do
    player = Player.new points: 1, has_permanent_ban: false
    policy = TennisRules.new player
    policy.to :play_tennis, {}
    expect(policy.instance_variable_get(:@actions)).to eq([:play_tennis])
    expect(policy.instance_variable_get(:@object)).to eq({})
  end
  
end
