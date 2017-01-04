class Score < ApplicationRecord

  belongs_to :game

  before_save :calc_points

  def calc_points
    hints = 0
    std_tries = 20 + (self.num_pos-5)*3 * (self.repeated? ? 2 : 1)
    std_time = 60 * (25 + (self.num_pos-5) * 10 ) * (self.repeated? ? 3 : 1)
    self.points = (10240 * (std_time/self.seconds) * ((std_tries - 2*hints)/self.tries)).to_i
  end

end
