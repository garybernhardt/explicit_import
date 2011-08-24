# explicit\_import

* http://github.com/garybernhardt/explicit\_import

## DESCRIPTION:

This module adds explicit imports to Ruby. By calling the `import` method during class or module definition, all constants in the module's namespace will be replaced by placeholders, except a few core types and those that are explicitly imported. For example, in this class:

    class Joe
      import 'File'

      def file_exists?(path)
        File.exists?(path)
      end

      def create_queue
        Queue.new
      end
    end

the File module will be available:

    >> Joe.new.file_exists?('/')
    => true

But other constants, like Queue, won't be:

    >> Joe.new.create_queue
    NoMethodError: undefined method `new' for #<ExplicitImport::CantTouchThis:0x10135a8c0>

As you can see, the constants are *present*, but have placeholder values:

    >> Joe.const_get(:Queue)
    => #<ExplicitImport::CantTouchThis:0x10135a8c0>

## ADVISABILITY:

Minimal. You almost certainly don't want to use this as it exists right now. For one thing, it only isolates the module from constants defined before the module itself; subsequent constant definitions will be missed.

There are probably ways to fix that. Patches are welcome if this kind of thing tickles your fancy.

