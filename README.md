# SequelActsAsVersionable

This gem is a port of Carlos Segura's acts_as_versionable at https://github.com/csegura/acts_as_versionable.

His gem is a plugin for ActiveRecord and I merely ported his code to a Sequel ORM plugin.



## Installation

Add this line to your application's Gemfile:

    gem 'sequel_acts_as_versionable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel_acts_as_versionable

## Usage

    class Thingy < Sequel::Model
        plugin :acts_as_versionable

        def before_validation
            super #note: you must call super if you implement before_validation for this plugin to work
            ..... your code
        end

        def validate
            super #note: you must call super if you implement validate for this plugin to work
            .... your code
        end
    end


I will provide some usage examples in the future. In the meantime, you can refer to https://github.com/csegura/acts_as_versionable
as my plugin is using the same exact interface.

## Example migration

Any model you this plugin on will require a migration...

    Sequel.migration do
      up do
        alter_table :thingies do
          add_column :version_number, Integer, :default => 0
          add_column :version_id, Integer
        end
      end

      down do
        alter_table :thingies do
          drop_column :version_number
          drop_column :version_id
        end
      end
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
