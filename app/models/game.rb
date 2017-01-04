class Game < ApplicationRecord

  has_many :game_hints
  has_many :game_tries
  has_one :score

  def max_num_hints
    self.num_pos - 2
  end

end
