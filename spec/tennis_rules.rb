class TennisRules < Umpire::Policy
  
  def rules
    allowed = [:play_tennis]
    allowed << :be_number_one if @subject.points >= 12_000
    allowed << :compete_in_wimbledon unless @subject.has_permanent_ban
    allowed
  end
  
end
