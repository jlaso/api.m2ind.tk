class Score < ApplicationRecord

  before_save :calc_points

  def calc_points
    hints = 0
    std_tries = 12+(self.num_pos-5)*2 * (self.repeated? ? 2 : 1)
    std_time = 60*(15+(self.num_pos-5)*6) * (self.repeated? ? 3 : 1)
    self.points = ((std_time/self.seconds) * ((std_tries - 2*hints)/self.tries)).to_i
  end

end
