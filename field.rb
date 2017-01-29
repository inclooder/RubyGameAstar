class Field
  attr_accessor :parent, :walkable, :cost
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
    @walkable = true
    @parent = nil
    @cost = nil
  end

  def walkable?
    @walkable
  end

  def toggle_walkable
    @walkable = !@walkable
  end

  def calc_cost(dest_x, dest_y)
    @cost = Math.hypot(x - dest_x, y - dest_y).round(2)
  end
end
