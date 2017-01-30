require 'rubygame'
require 'thread'
require_relative 'exit_event'
require_relative 'mouse_event'

include Rubygame

class RubygameEngine
  def initialize
    @queue = EventQueue.new
    @clock = Clock.new
    @clock.target_framerate = 30
    @events = []
  end

  def create_window(width, height)
    @screen = Screen.new [width, height], 0, [HWSURFACE, DOUBLEBUF]
  end

  def shift_event
    @events.shift
  end

  def update_window
    @queue.each do |ev|
      case ev
      when QuitEvent
        @events << ExitEvent.new
      when MouseDownEvent
        pos = ev.pos
        @events << MouseEvent.new(pos[0], pos[1], :down)
      end
    end
    @screen.update
    @clock.tick
  end

  def fill_box(topleft, bottomright, color)
    @screen.draw_box_s(topleft, bottomright, color)
  end

  def fill_circle(center, radius, color)
    @screen.draw_circle_s(center, radius, color)
  end

  def fill(color)
    @screen.fill(color)
  end

  def exit
    Rubygame.quit
  end
end
