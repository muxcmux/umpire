class DrinkingRules < Umpire::Policy
  
  def rules
    allowed = []
    allowed << allow_drink?
    allowed
  end
  
  def allow_drink?
    return :play_tennis unless @subject.is_playing_a_match
    return :play_tennis unless @object.alcohol
  end
  
end
