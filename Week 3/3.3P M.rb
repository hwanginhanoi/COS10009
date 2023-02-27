require 'rubygems'
require 'gosu'
require './circle'

# The screen has layers: Background, middle, top
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

class DemoWindow < Gosu::Window
  def initialize
    super(640, 400, false)
  end

  def draw

    img2 = Gosu::Image.new(Circle.new(50))

    #sky
    Gosu.draw_rect(0, 0, 640, 400, Gosu::Color::AQUA, ZOrder::BACKGROUND, mode=:default)

    #road
    Gosu.draw_rect(0, 320, 640, 80, Gosu::Color::BLACK, ZOrder::MIDDLE, mode=:default)

    Gosu.draw_rect(10, 350, 60, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)

    Gosu.draw_rect(90, 350, 60, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)

    Gosu.draw_rect(170, 350, 60, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)

    Gosu.draw_rect(250, 350, 60, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)

    Gosu.draw_rect(330, 350, 60, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)

    Gosu.draw_rect(410, 350, 60, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)

    Gosu.draw_rect(490, 350, 60, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)

    Gosu.draw_rect(570, 350, 60, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)


    #house
    Gosu.draw_rect(360, 160, 260, 160, Gosu::Color::GRAY, ZOrder::TOP, mode=:default)

    Gosu.draw_triangle(360, 160, Gosu::Color::RED, 620, 160, Gosu::Color::RED, 490, 40, Gosu::Color::RED, ZOrder::TOP, mode=:default)

    Gosu.draw_rect(470,260, 40, 60, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)

    #tree
    Gosu.draw_rect(100,230, 50, 90, 0xff_964B00, ZOrder::TOP, mode=:default)

    img2.draw(75, 120, ZOrder::TOP, 1, 1, Gosu::Color::GREEN, mode=:default)

    img2.draw(30, 160, ZOrder::TOP, 1, 1, Gosu::Color::GREEN, mode=:default)

    img2.draw(120, 160, ZOrder::TOP, 1, 1, Gosu::Color::GREEN, mode=:default)

    img2.draw(20, 20, ZOrder::TOP, 0.5, 0.5, Gosu::Color::YELLOW, mode=:default)

    #cloud

    Gosu.draw_rect(240, 40, 50, 50, Gosu::Color::WHITE, ZOrder::TOP,mode=:default)

    img2.draw(220,40, ZOrder::TOP, 0.5,0.5 ,Gosu::Color::WHITE, mode=:default)

    img2.draw(260,40, ZOrder::TOP, 0.5,0.5 ,Gosu::Color::WHITE, mode=:default)

    img2.draw(240,20, ZOrder::TOP, 0.5,0.5 ,Gosu::Color::WHITE, mode=:default)

  end
end

DemoWindow.new.show