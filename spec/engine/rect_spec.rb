require_relative '../../lib/engine/rect'
require_relative '../../lib/engine/point'

RSpec.describe Engine::Rect do
  describe '#center' do
    subject do
      described_class.new(5, 7, 10, 10).center
    end
    it 'returns point' do
      is_expected.to be_a(Engine::Point)
    end

    it 'returns center of rectangle' do
      is_expected.to eq Engine::Point.new(10, 12)
    end
  end

  describe '#collide_point?' do
    subject do
      described_class.new(43, 10, 80, 80)
                     .collide_point?(point.x, point. y)
    end
    context 'when point collide' do
      let(:point) { Engine::Point.new(50, 18) }
      it 'returns true' do
        is_expected.to be true
      end
    end

    context 'when point not collide' do
      let(:point) { Engine::Point.new(42, 11) }
      it 'returns false' do
        is_expected.to be false
      end
    end
  end

  describe '#topleft' do
    subject do
      described_class.new(3, 2, 4, 3).topleft
    end
    it 'returns top-left corner' do
      is_expected.to eq Engine::Point.new(3, 2)
    end
  end

  describe '#bottomright' do
    subject do
      described_class.new(3, 2, 4, 3).bottomright
    end
    it 'returns bottom-right corner' do
      is_expected.to eq Engine::Point.new(7, 5)
    end
  end
end
