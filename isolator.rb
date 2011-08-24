CantTouchThis = Class.new do
  def to_s
    '<CantTouchThis>'
  end
end.new

class Stripper
  def self.strip(klass, excludes)
    klass.class_eval do
      constants = (Stripper::constants_to_remove - excludes.map(&:to_s))
      constants.each do |c|
        self.const_set c.to_sym, CantTouchThis
      end

    end
  end

  def self.import klass, *names
    strip(klass, names)
    names.each do |name|
      constant = Stripper::const_get(name)
      klass.const_set(name, constant)
    end
  end

  def self.constants_to_remove
    exceptions = %w{Object Class Module}
    Object.constants - exceptions
  end
end

class Module
  def import(*args)
    Stripper::import(self, *args)
  end
end

class Joe
  import :File

  def self.get_io
    IO
  end

  def self.get_file
    File
  end
end

if __FILE__ == $0
  # These print the constants; they still exist
  puts IO.inspect
  puts File.inspect

  # This prints <CantTouchThis>; the constant is gone inside Joe
  puts Joe.get_io.inspect

  # This prints File; Joe imports it, so it can see it
  puts Joe.get_file.inspect
end

