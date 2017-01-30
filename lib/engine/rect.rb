require_relative 'point'

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
  end
end
