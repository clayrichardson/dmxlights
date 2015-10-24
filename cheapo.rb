
$LOAD_PATH << '.'

require_relative 'lib/rdmx/rdmx'
require_relative 'lib/colormath/lib/colormath'

include Rdmx


class Led < Fixture
  self.channels = :mode, :brightness, :red, :green, :blue, :blank6, :blank7, :blank8, :blank9, :blank10, :blank11, :blank12, :blank13, :blank14, :blank15, :blank16, :blank17, :blank18, :blank19, :blank20, :blank21, :blank22, :blank23, :blank24, :blank25, :blank26, :blank27, :blank28, :blank29, :blank30, :blank31, :blank32
  #self.channels = :mode, :brightness, :red, :green, :blue, :blank6, :blank7
  #self.channels = :mode, :brightness, :red, :green, :blue
  #self.channels = :red, :green, :blue
end

leds = 5

@u = Universe.new(ARGV[0], Led => leds)
puts @u.inspect
puts @u.fixtures.inspect

#puts @u.fixtures[0].all = [mode, brightness, 255, 0, 255, 0, 0]

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
        (leds).times do |led|
            intensity = 255
            mode = 255
            @u.fixtures[led].all = [mode, intensity, rand(0..255), rand(0..255), rand(0..255), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; continue
        end
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
            scale = 255
            mode = 255
            light1 = [mode, intensity, (color1.red*scale).to_i, (color1.green*scale).to_i, (color1.blue*scale).to_i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; continue
            light2 = [mode, intensity, (color2.red*scale).to_i, (color2.green*scale).to_i, (color2.blue*scale).to_i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; continue
            light3 = [mode, intensity, (color3.red*scale).to_i, (color3.green*scale).to_i, (color3.blue*scale).to_i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; continue

            @u.fixtures[0].all = light1
            @u.fixtures[1].all = light2
            @u.fixtures[2].all = light3
            #@u.fixtures[3].all = light4

            puts @u.fixtures[0].inspect
            puts @u.fixtures[1].inspect
            puts @u.fixtures[2].inspect
            #puts @u.fixtures[3].inspect

        end

    end
  end
end


multi_rainbow = Animation.new do
  frame.new do
    puts "rainbows!"
    loop do
        lights = []
        colors = []
        intensity = 255
        mode = 255
        scale = 255
        offset = 360/leds
        step = 2
        (step..360).step(step) do |degree|
            (leds).times do |led|
                #puts "led: #{led}, degree: #{degree}, offset: #{offset*led} result: #{degree+offset*led}"
                colors[led] = ColorMath::HSL.new(degree+offset*led, 1, 0.5)
                lights[led] = [mode, intensity, (colors[led].red*scale).to_i, (colors[led].green*scale).to_i, (colors[led].blue*scale).to_i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; continue
                @u.fixtures[led].all = lights[led]
            end
            #puts "#{lights}"
        end
    end
  end
end

processed_rainbow = Animation.new do
    lights = []
    colors = []
    intensity = 255
    mode = 255
    scale = 255
    offset = 360/leds
    step = 5
    processed = []
    (step..360).step(step) do |degree|
        lights = []
        (leds).times do |led|
            puts "led: #{led}, degree: #{degree}, offset: #{offset*led} result: #{degree+offset*led}"
            colors[led] = ColorMath::HSL.new(degree+offset*led, 1, 0.5)
            lights.push([mode, intensity, (colors[led].red*scale).to_i, (colors[led].green*scale).to_i, (colors[led].blue*scale).to_i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
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
                    #puts "poop #{light}"
                    @u.fixtures[index].all = light; continue
                end
            end
        end
    end
end


#blink.go!
#random.go!
#strobe.go!
#rainbow.go!
processed_rainbow.go!
