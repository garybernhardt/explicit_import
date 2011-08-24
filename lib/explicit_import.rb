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
      name_components = constant_path.split('::')
      constant = find_constant(name_components)
      set_constant(klass, name_components, constant)
    end
  end

  def self.find_constant(name_components)
    object = Object
    name_components.each do |component|
      object = object.const_get(component)
    end
    object
  end

  def self.set_constant(object, name_components, value)
    if name_components.length == 1
      imported_name = name_components.first
      set_terminal_constant(object, imported_name, value)
    else
      component = name_components.first
      rest = name_components[1..-1]
      make_constant_path_component_exist(object, component)
      set_constant(object.const_get(component), rest, value)
    end
  end

  def self.set_terminal_constant(object, imported_name, value)
    object.remove_const!(imported_name) if object.const_defined?(imported_name)
    object.const_set(imported_name, value)
  end

  def self.make_constant_path_component_exist(object, component)
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

  def remove_const!(const_name)
    remove_const(const_name)
  end
end

