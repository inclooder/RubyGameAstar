require "rubygame"
require_relative 'board'
require_relative 'field'

include Rubygame

class Astar
  BG_COLOR = 'white'

  def initialize
    @map = Board.new(10, 10)

    @start_point = @map.at(0, 2)
    @end_point = @map.at(4, 8)

    reset_parents_and_costs
    @path = find_path

    @screen = Screen.new [600,600], 0, [HWSURFACE, DOUBLEBUF]
    @cell_width = @screen.size[0] / @map.width
    @cell_height = @screen.size[1] / @map.height
    @crad = @cell_height / 2
    @queue = EventQueue.new
    @clock = Clock.new
    @clock.target_framerate = 30
  end

  def find_path
    open_list = []
    close_list = []

    @start_point.calc_cost(@end_point.x, @end_point.y)

    open_list << @start_point

    while(open_list.size > 0)
      p = nil
      open_list.each do |e|
        if p.nil?
          p = e
        else
          p = e if e.cost < p.cost 
        end
      end

      open_list.delete(p)
      close_list << p

      break if p.x == @end_point.x && p.y == @end_point.y


      field = @map.at(p.x, p.y)
      avil_moves = @map.neighbors_for(field)

      avil_moves.each do |m|
        if m.walkable? and not close_list.include?(m)
          unless open_list.include?(m)
            m.parent = p
            m.calc_cost(@end_point.x, @end_point.y)
            open_list << m
          end
        end
      end
    end

    path = []

    p = @end_point
    while(p != nil)
      path.push p
      p = p.parent
    end

    return path
  end

  def reset_parents_and_costs
    @map.each_field do |field|
      field.cost = nil
      field.parent = nil
    end
  end

  def draw_map
    (0...@map.width).each do |x|
      (0...@map.height).each do |y|
        x_pos = x * @cell_width
        y_pos = y * @cell_height
        r = Rect.new(x_pos, y_pos, @cell_width, @cell_height)
        node = @map.at(x, y)
        c = r.center()
        unless node.walkable?
          @screen.draw_box_s(r.topleft, r.bottomright, 'gray')
        end
        if(@path.include? node)
          @screen.draw_circle_s(c, @crad, 'orange')
        end
      end
    end
  end

  def draw_background
    @screen.fill BG_COLOR
  end


  def run
    loop do
      update
      draw
      @clock.tick
    end
  end

  def get_map_position_from_screen coord
    cx, cy = coord

    (0...@map.width).each do |x|
      (0...@map.height).each do |y|
        x_pos = x * @cell_width
        y_pos = y * @cell_height
        r = Rect.new(x_pos, y_pos, @cell_width, @cell_height)
        if r.collide_point? cx, cy
          return [x, y]
        end
      end
    end

    return nil
  end

  def handle_mouse_click ev
    map_point = get_map_position_from_screen(ev.pos)
    unless map_point.nil?
      ix, iy = map_point
      @map.at(ix, iy).toggle_walkable
      reset_parents_and_costs
      @path = find_path
    end
  end

  def update
    @queue.each do |ev|
      case ev
      when QuitEvent
        Rubygame.quit
        exit
      when MouseDownEvent
        handle_mouse_click ev
      end
    end
  end

  def draw
    draw_background
    draw_map
    @screen.update
  end
end

game = Astar.new
game.run
