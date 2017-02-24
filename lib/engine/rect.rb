require_relative 'point'
require_relative 'vector'

module Engine
  class Rect < Struct.new(:x, :y, :width, :height)
    def center
      cx = x + (width / 2)
      cy = y + (height / 2)
      Point.new(cx, cy)
    end

    def collide_point?(px, py)
      br = bottomright
      px > x && py > y && px < br.x && py < br.y
    end

    def topleft
      Point.new(x, y)
    end

    def bottomright
      Point.new(x + width, y + height)
    end

    def topright
      Point.new(x + width, y)
    end

    def bottomleft
      Point.new(x, y + height)
    end

    def half_width
      width / 2
    end

    def half_height
      height / 2
    end

    def center
      Point.new(half_width + x, half_height + y)
    end

    def center_at(point)
      center_point = center
      dir_x = point.x - center_point.x
      dir_y = point.y - center_point.y
      move_by(Vector.new(dir_x, dir_y))
    end

    def move_by(vector)
      self.x += vector.dir_x
      self.y += vector.dir_y
    end
  end
end
