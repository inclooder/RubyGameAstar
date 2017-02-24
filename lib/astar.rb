require_relative 'board'
require_relative 'field'
require_relative 'engine/all'

class Astar
  include Engine

  BG_COLOR = 'white'
  WIDTH = 600
  HEIGHT = 600

  def initialize
    @engine = Engine.new(GosuEngine.new, updater: self, drawer: self)
    @board = Board.new(10, 10)

    @start_point = @board.at(1, 2)
    @end_point = @board.at(4, 8)

    reset_parents_and_costs
    @path = find_path

    @cell_width = WIDTH / @board.width
    @cell_height = HEIGHT / @board.height
    @crad = @cell_height / 2
    @engine.create_window(WIDTH, HEIGHT)
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


      field = @board.at(p.x, p.y)
      avil_moves = @board.neighbors_for(field)

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
    @board.each_field do |field|
      field.cost = nil
      field.parent = nil
    end
  end

  def draw_map
    @board.each_coord do |x, y|
      x_pos = x * @cell_width
      y_pos = y * @cell_height
      r = Rect.new(x_pos, y_pos, @cell_width, @cell_height)
      node = @board.at(x, y)
      c = r.center()
      unless node.walkable?
        @engine.fill_box(r, 'gray')
      end
      if(@path.include? node)
        @engine.fill_circle(c, @crad, 'orange')
      end
    end
  end

  def draw_background
    @engine.fill BG_COLOR
  end

  def get_map_position_from_screen(cx, cy)
    @board.each_coord do |x, y|
      x_pos = x * @cell_width
      y_pos = y * @cell_height
      r = Rect.new(x_pos, y_pos, @cell_width, @cell_height)
      return [x, y] if r.collide_point? cx, cy
    end
    return nil
  end

  def handle_mouse_click ev
    map_point = get_map_position_from_screen(ev.x, ev.y)
    unless map_point.nil?
      ix, iy = map_point
      @board.at(ix, iy).toggle_walkable
      reset_parents_and_costs
      @path = find_path
    end
  end

  def update
    event = @engine.shift_event
    case event
    when ExitEvent
      @engine.exit
      exit
    when MouseEvent
      if event.state == :down
        handle_mouse_click event
      end
    end
  end

  def draw
    draw_background
    draw_map
    @engine.update_window
  end
end
