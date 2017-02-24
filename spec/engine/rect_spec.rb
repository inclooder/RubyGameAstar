require_relative '../../lib/engine/rect'
require_relative '../../lib/engine/point'

RSpec.describe Engine::Rect do
  describe '#center' do
    it 'returns point' do
      rect = Engine::Rect.new(5, 7, 10, 10)

      expect(rect.center).to be_a(Engine::Point)
    end

    it 'returns center of rectangle' do
      rect = Engine::Rect.new(5, 7, 10, 10)

      expect(rect.center).to eq Engine::Point.new(10, 12)
    end
  end

  describe '#collide_point?' do
    it 'returns true when point collide' do
      rect = Engine::Rect.new(43, 10, 80, 80) 
      point = Engine::Point.new(50, 18)

      expect(rect.collide_point?(point.x, point.y)).to be true
    end

    it 'returns false when point not collide' do
      rect = Engine::Rect.new(43, 10, 80, 80) 
      point = Engine::Point.new(42, 11)

      expect(rect.collide_point?(point.x, point.y)).to be false
    end
  end

  describe '#topleft' do
    it 'returns top-left corner' do
      rect = Engine::Rect.new(3, 2, 4, 3)
      
      expect(rect.topleft).to eq Engine::Point.new(3, 2)
    end
  end

  describe '#bottomright' do
    it 'returns bottom-right corner' do
      rect = Engine::Rect.new(3, 2, 4, 3)

      expect(rect.bottomright).to eq Engine::Point.new(7, 5)
    end
  end

  describe '#half_width' do
    it 'returns half of width' do
      rect = Engine::Rect.new(0, 0, 10, 10)

      expect(rect.half_width).to eq 5
    end
  end

  describe '#half_height' do
    it 'returns half of height' do
      rect = Engine::Rect.new(0, 0, 10, 10)

      expect(rect.half_height).to eq 5
    end
  end
end
