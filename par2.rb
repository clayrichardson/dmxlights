
$LOAD_PATH << '.'

require_relative 'lib/rdmx/rdmx'
require_relative 'lib/colormath/lib/colormath'

include Rdmx


class Led < Fixture
  self.channels = :dimmer, :strobe, :control, :speed, :red, :green, :blue, :white
end

leds = 4

@u = Universe.new(ARGV[0], Led => leds)

puts @u.inspect
puts @u.fixtures.inspect


#puts @u.fixtures[0].all = [255, 0, 0, 0, 255, 0, 0, 0]

blink = Animation.new do
  frame.new do
    puts "blinking red and green, then green and blue"
    100.times do
        @u.fixtures[0].all = [255, 0, 0, 0, 255, 0, 255, 0]; continue
        sleep(1)
        #@u.fixtures[0].all = [255, 0, 0, 0, 0, 0, 255, 0]; continue
        sleep(1)
    end
  end
end

random = Animation.new do
  frame.new do
    puts "blinking random!"
    loop do
        #stuff = [rand(0..255), 0, 0, 0, rand(0..255), rand(0..255), rand(0..255), rand(0..255)]; continue
        intensity = 255
        min = 0
        max = 75
        stuff = [intensity, 0, 0, 0, rand(min..max), rand(min..max), rand(min..max), 0]; continue
        @u.fixtures[0].all = stuff
        #intensity = rand(0..255)
        stuff = [intensity, 0, 0, 0, rand(min..max), rand(min..max), rand(min..max), 0]; continue
        @u.fixtures[1].all = stuff
        #intensity = rand(0..255)
        stuff = [intensity, 0, 0, 0, rand(min..max), rand(min..max), rand(min..max), 0]; continue
        @u.fixtures[2].all = stuff
        stuff = [intensity, 0, 0, 0, rand(min..max), rand(min..max), rand(min..max), 0]; continue
        @u.fixtures[3].all = stuff
        sleep(5)
        #puts @u.inspect
        #puts @u.fixtures.inspect
        #@u.fixtures[0].all = [255, 0, 0, 0, 0, 120, 255, 0]; continue
    end
  end
end

strobe = Animation.new do
  frame.new do
    puts "blinking random!"
    loop do
        #stuff = [rand(0..255), 0, 0, 0, rand(0..255), rand(0..255), rand(0..255), rand(0..255)]; continue
        intensity = 0
        stuff = [intensity, 0, 0, 0, intensity, intensity, intensity, intensity]; continue
        @u.fixtures[0].all = stuff
        @u.fixtures[1].all = stuff
        @u.fixtures[2].all = stuff

        intensity = 255
        stuff = [intensity, 0, 0, 0, intensity, intensity, intensity, intensity]; continue
        @u.fixtures[0].all = stuff
        @u.fixtures[1].all = stuff
        @u.fixtures[2].all = stuff
        #puts @u.inspect
        #puts @u.fixtures.inspect
        #@u.fixtures[0].all = [255, 0, 0, 0, 0, 120, 255, 0]; continue
    end
  end
end


rainbow = Animation.new do
  frame.new do
    puts "rainbows!"
    loop do

        (0..360).step(2) do |degree|
            color1 = ColorMath::HSL.new(degree, 1, 0.5)
            color2 = ColorMath::HSL.new(degree+360/4, 1, 0.5)
            color3 = ColorMath::HSL.new(degree-360/4, 1, 0.5)
            color4 = ColorMath::HSL.new(degree-360/4, 1, 0.5)
            intensity = 255
            scale = 1
            light1 = [intensity, 0, 0, 0, [(color1.red*intensity).to_i*scale, intensity].min, [(color1.green*intensity).to_i*scale, intensity].min, [(color1.blue*intensity).to_i*scale, intensity].min, 0]; continue
            # puts light1
            light2 = [intensity, 0, 0, 0, (color2.red*scale).to_i, (color2.green*scale).to_i, (color2.blue*scale).to_i, 0]; continue
            light3 = [intensity, 0, 0, 0, (color3.red*scale).to_i, (color3.green*scale).to_i, (color3.blue*scale).to_i, 0]; continue
            light4 = [intensity, 0, 0, 0, (color4.red*scale).to_i, (color4.green*scale).to_i, (color4.blue*scale).to_i, 0]; continue
            @u.fixtures[0].all = light1
            @u.fixtures[1].all = light2
            @u.fixtures[2].all = light3
            @u.fixtures[3].all = light3

        end

    end
  end
end

processed_rainbow = Animation.new do
    lights = []
    colors = []
    intensity = 100
    strobe = 0
    control = 0
    speed = 255

    scale = 100
    offset = 360/leds
    step = 1
    processed = []
    (step..360).step(step) do |degree|
        lights = []
        (leds).times do |led|
            puts "led: #{led}, degree: #{degree}, offset: #{offset*led} result: #{degree+offset*led}"
            colors[led] = ColorMath::HSL.new(degree+offset*led, 1, 0.5)
            lights.push([intensity, strobe, control, speed, (colors[led].red*scale).to_i, (colors[led].green*scale).to_i, (colors[led].blue*scale).to_i, 0])
        end
        #puts "lights: #{lights}"
        processed.push(lights)
    end 
    #puts "derp1 #{processed[0]}"
    #puts "derp2 #{processed[1]}"
    #puts "derp3 #{processed[2]}"
    frame.new do
        puts "rainbows!"
        loop do
            processed.each do |lights|
                #puts "#{lights}"
                lights.each_with_index do |light, index|
                    #puts "poop #{index} #{light}"
                    @u.fixtures[index].all = light; continue
                end
                sleep(0.0)
            end
        end
    end 
end


#blink.go!
#random.go!
#strobe.go!
#rainbow.go!
processed_rainbow.go!
