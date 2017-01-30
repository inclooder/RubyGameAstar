class Engine
  def initialize(implementation)
    @impl = implementation
  end

  def create_window(width, height)
    @impl.create_window(width, height)
  end

  def update_window
    @impl.update_window
  end

  def fill_box(topleft, bottomright, color)
    @impl.fill_box(topleft, bottomright, color)
  end

  def outline_box(topleft, bottomright, color)
    @impl.outline_box(topleft, bottomright, color)
  end

  def fill_circle(center, radius, color)
    @impl.fill_circle(center, radius, color)
  end

  def fill(color)
    @impl.fill(color)
  end

  def exit
    @impl.exit
  end

  def shift_event
    @impl.shift_event
  end
end
