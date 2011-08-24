class ExplicitImport
  CantTouchThis = Class.new do
    def to_s
      '<CantTouchThis>'
    end
  end.new

  def self.strip(klass, excludes)
    klass.class_eval do
      constants = (ExplicitImport::constants_to_remove - excludes.map(&:to_s))
      constants.each do |c|
        self.const_set c.to_sym, CantTouchThis
      end

    end
  end

  def self.import klass, *names
    strip(klass, names)
    names.each do |name|
      constant = const_get(name)
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
    ExplicitImport::import(self, *args)
  end
end

