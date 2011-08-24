class ExplicitImport
  class CantTouchThis
  end

  def self.strip(klass)
    klass.class_eval do
      constants = ExplicitImport::constants_to_remove
      constants.each do |c|
        self.const_set c.to_sym, CantTouchThis.new
      end
    end
  end

  def self.import klass, *constant_paths
    strip(klass)
    constant_paths.each do |constant_path|
      path_components = constant_path.split('::')
      constant = find_constant(path_components)
      set_constant(klass, path_components, constant)
    end
  end

  def self.find_constant(path_components)
    object = Object
    path_components.each do |component|
      object = object.const_get(component)
    end
    object
  end

  def self.set_constant(object, path_components, value)
    if path_components.length == 1
      imported_name = path_components.first
      set_terminal_constant(object, imported_name, value)
    else
      component = path_components.first
      rest = path_components[1..-1]
      ensure_intermediate_constant_exists(object, component)
      set_constant(object.const_get(component), rest, value)
    end
  end

  def self.set_terminal_constant(object, imported_name, value)
    object.remove_const!(imported_name) if object.const_defined?(imported_name)
    object.const_set(imported_name, value)
  end

  def self.ensure_intermediate_constant_exists(object, component)
    if object.const_get(component).is_a? CantTouchThis
      object.remove_const!(component)
      object.const_set(component, Module.new)
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

  def remove_const!(*args)
    remove_const(*args)
  end
end

