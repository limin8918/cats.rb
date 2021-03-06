require_relative 'spec_helper'
require 'data.either'
describe Either do
  it '#map' do
    expect(Right.new(1).map {|x| x + 1}).to eq(Right.new(2))
    expect(Left.new('hehe').map {|x| x + 1}).to eq(Left.new('hehe'))
  end

  it '#left_map' do
    expect(Right.new(1).left_map {|x| x + 1}).to eq(Right.new(1))
    expect(Left.new(1).left_map {|x| x + 1}).to eq(Left.new(2))
  end

  it '#bimap' do
    expect(Right.new(1).bimap ->(x){x-1}, ->(x){x+1}).to eq(Right.new(2))
    expect(Left.new(1).bimap ->(x){x-1}, ->(x){x+1}).to eq(Left.new(0))
  end

  it '#get_or_else' do
    expect(Right.new(1).get_or_else('')).to eq(1)
    expect(Left.new(1).get_or_else('')).to eq('')
  end

  it '#inspect' do
    expect(Right.new(1).inspect).to eq('#<Right value=1>')
    expect(Left.new(1).inspect).to eq('#<Left value=1>')
  end

  it '#>=' do
    expect(Right.new(1).>= { |x| Left.new } ).to eq(Left.new)
    expect(Left.new(1).flat_map { |x| Left.new } ).to eq(Left.new(1))
  end

  it '#when' do
    expect(Right.new(1).when({Right: ->x{x+1} })).to eq(2)
    expect(Right.new(1).when({Left: ->x{x+1} })).to eq(nil)
    expect(Right.new(1).when({Left: ->x{x+1}, _: ->x{x-1} })).to eq(0)
  end

  it 'partition' do
    expect(Either.partition [Left.new(1),Right.new(5), Right.new(2)]).to eq([[1],[5, 2]])
  end

  it 'lefts' do
    expect(Either.lefts [Left.new(1),Right.new(5), Right.new(2)]).to eq([1])
  end

  it 'rights' do
    expect(Either.rights [Left.new(1),Right.new(5), Right.new(2)]).to eq([5,2])
  end

  it '#>>' do
    expect(Right.new(1) > Left.new > Right.new(1)).to eq(Left.new)
  end
  
  describe Right do
    it '#==' do
      expect(Right.new(1) == Left.new(1)).to be false
    end
  end

  describe Left do
    it '#==' do
      expect(Left.new(1) == Right.new(1)).to be false
    end
  end
end
