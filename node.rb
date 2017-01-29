include Rubygame

class Node
  attr_accessor :x, :y, :parent, :walkable, :cost
  def initialize(x,y, walkable)
    @x = x
    @y = y
    @walkable = walkable
    @parent = nil
    @cost = nil
  end

  def calc_cost(dest_x, dest_y)
    @cost = Math.hypot(x - dest_x, y - dest_y).round(2)
  end
end
