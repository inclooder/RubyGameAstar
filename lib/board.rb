require 'byebug'

class Board
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @mat = create_mat
  end

  def each_field
    each_coord do |x, y|
      at(x, y)
    end
  end

  def each_coord
    (0...width).each do |x|
      (0...height).each do |y|
        yield(x, y)
      end
    end
  end

  def at(x, y)
    @mat[y][x]
  rescue
    nil
  end

  def set(x, y, val)
    @mat[y][x] = val
  end

  def neighbors_for(field)
    px, py = field.x, field.y
    fields = [
      at(px + 1, py),
      at(px - 1, py),
      at(px, py + 1),
      at(px, py - 1),
      at(px + 1, py + 1),
      at(px - 1, py - 1),
      at(px - 1, py + 1),
      at(px + 1, py - 1)
    ]
    fields.compact.select do |f|
      f.x < width && f.x > 0 && f.y < height && f.y > 0
    end
  end

  private

  def create_mat
    (0...width).map do |x|
      (0...height).map do |y|
        Field.new(x, y)
      end
    end
  end
end
