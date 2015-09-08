class Player
  
  attr_accessor :name,
                :points,
                :has_permanent_ban,
                :is_playing_a_match

  def initialize attrs = {}
    @name = attrs[:name]
    @points = attrs[:points]
    @has_permanent_ban = attrs[:has_permanent_ban]
    @is_playing_a_match = attrs[:is_playing_a_match]
  end
  
end
