require 'gosu'

module Engine

  class GosuEngine
    COLORS = {
      'gray' => Gosu::Color::GRAY,
      'white' => Gosu::Color::WHITE,
      'orange' => Gosu::Color.new(255, 255, 165, 0)
    }
    class Window < Gosu::Window
      def initialize(width, height, updater, drawer)
        super(width, height)
        @updater = updater
        @drawer = drawer
      end

      def update
        @updater.update
      end

      def draw
        @drawer.draw
      end
    end

    def initialize
    end

    def create_window(width, height, updater, drawer)
      @width = width
      @height = height
      @window = Window.new(@width, @height, updater, drawer)
      @window.show
    end

    def update_window
    end

    def fill_box(rect, color)
      color = COLORS[color]
      @window.draw_quad(rect.topleft.x, rect.topleft.y, color, 
                        rect.topright.x, rect.topright.y, color, 
                        rect.bottomright.x, rect.bottomright.y, color, 
                        rect.bottomleft.x, rect.bottomleft.y, color)
    end

    def outline_box(topleft, bottomright, color)
    end

    def fill_circle(center, radius, color)
      #TODO: change this to actual circle
      rect = Rect.new(0, 0, 60, 60)
      rect.center_at(center)
      fill_box(rect, color)
    end

    def fill(color)
      color = COLORS[color]
      @window.draw_quad(0, 0, color, @width, 0, color, @width, @height, color, 0, @height, color)
    end

    def exit
    end

    def shift_event
    end
  end
end
