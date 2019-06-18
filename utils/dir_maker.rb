require 'fileutils'

class DirMaker
  attr_accessor :ou, :dc1, :dc2, :path, :raw_path

  def initialize(raw_path)
    @raw_path = raw_path
  end

  def self.create(path)
    dir_maker = new(path)
    dir_maker.make_path
    dir_maker
  end

  def make_path
    part1, part2, part3 = raw_path.split(',')
    @ou = part1.split('=')[1]
    @dc1 = part2.split('=')[1]
    @dc2 = part3.split('=')[1]
    @path = File.join(@ou, @dc1, @dc2)
    begin
      FileUtils.mkdir_p @path
    rescue => e
      puts e
    end
  end
end
