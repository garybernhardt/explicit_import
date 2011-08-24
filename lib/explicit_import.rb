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

  def self.set_constant(klass, name_components, constant)
    intermediate_components = name_components[0...-1]
    imported_name = name_components.last
    object = klass
    intermediate_components.each do |component|
      if object.const_get(component).is_a? CantTouchThis
        object.remove_const!(component)
        object.const_set(component, Module.new)
        object = object.const_get(component)
      else
        object = object.const_get(component)
      end
    end
    object.remove_const!(imported_name) if object.const_defined?(imported_name)
    object.const_set(imported_name, constant)
  end

  def self.restore_constant(object, name, new_object)
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

