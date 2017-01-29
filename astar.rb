require "rubygame"
require_relative 'node'

include Rubygame

class Game
  BG_COLOR = 'white'

  def initialize
    @map_width = 40
    @map_height = 40
    @map = []

    (0...@map_width).each do |x|
      (0...@map_height).each do |y|
        @map[y]=[] if @map[y].nil?
        @map[y][x] = 0
      end
    end


    @start_point = [4,5]
    @end_point = [24, 8]


    create_nodes_map
    @mypath = find_path

    @screen = Screen.new [800,600], 0, [HWSURFACE, DOUBLEBUF]
    @cell_width = @screen.size[0] / @map_width
    @cell_height = @screen.size[1] / @map_height
    @crad = @cell_height / 2
    @queue = EventQueue.new
    @clock = Clock.new
    @clock.target_framerate = 30
  end

  def point_neighbors(px, py)
    neighbors_coordinates = []
    neighbors_coordinates << [px + 1, py]
    neighbors_coordinates << [px - 1, py]
    neighbors_coordinates << [px, py + 1]
    neighbors_coordinates << [px, py - 1]
    neighbors_coordinates << [px + 1, py + 1]
    neighbors_coordinates << [px - 1, py - 1]
    neighbors_coordinates << [px - 1, py + 1]
    neighbors_coordinates << [px + 1, py - 1]
    return neighbors_coordinates
  end

  def find_path
    open_list = []
    close_list = []

    start_node =  @nodes_map[@start_point[0]][@start_point[1]]
    start_node.calc_cost(@end_point[0], @end_point[1])

    end_node =  @nodes_map[@end_point[0]][@end_point[1]]

    open_list << start_node

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

      if p.x == @end_point[0] and p.y == @end_point[1]
        break
      end

      #przylegle pola
      avil_moves = []

      point_neighbors(p.x, p.y).each do |pn|
        if pn[0] < @map_width and pn[0] > 0 and pn[1] < @map_height and pn[1] > 0
          move = @nodes_map[pn[0]][pn[1]]
          avil_moves << move 
        end
      end

      avil_moves.each do |m|
        unless m.nil?
          if m.walkable and not close_list.include?(m)
            unless open_list.include?(m)
              m.parent = p
              m.calc_cost(@end_point[0], @end_point[1])
              open_list << m
            end
          end
        end
      end

    end


    path = []

    p = end_node
    while(p != nil)
      path.push p
      p = p.parent
    end


    return path
  end

  def create_nodes_map
    @nodes_map = []
    (0...@map_width).each do |x|
      @nodes_map[x] = []

      (0...@map_height).each do |y|
        walkable = @map[y][x] == 0
        @nodes_map[x][y] = Node.new(x, y, walkable)
      end
    end
  end

  def draw_map
    (0...@map_width).each do |x|
      (0...@map_height).each do |y|
        x_pos = x * @cell_width
        y_pos = y * @cell_height

        r = Rect.new(x_pos, y_pos, @cell_width, @cell_height)

        node = @nodes_map[x][y]


        c = r.center()

        unless node.walkable
          @screen.draw_circle_s(c, @crad, 'gray')
        end


        if(@mypath.include? node)
          @screen.draw_circle_s(c, @crad, 'orange')
        end

        @screen.draw_box(r.topleft, r.bottomright, 'black');

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

  def handle_keys ev
  end


  def get_map_position_from_screen coord
    cx = coord[0]
    cy = coord[1]

    (0...@map_width).each do |x|
      (0...@map_height).each do |y|
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
    map_point = get_map_position_from_screen ev.pos
    unless map_point.nil?
      ix = map_point[0]
      iy = map_point[1]

      val = @map[iy][ix]
      if val == 1
        @map[iy][ix] = 0
      else
        @map[iy][ix] = 1
      end
      create_nodes_map
      @mypath = find_path
    end

  end

  def update

    @queue.each do |ev|
      case ev
      when QuitEvent
        Rubygame.quit
        exit
      when KeyDownEvent
        handle_keys ev
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

game = Game.new
game.run


