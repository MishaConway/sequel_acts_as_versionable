require "sequel_acts_as_versionable/version"

module Sequel
  module Plugins
    module ActsAsVersionable
      def self.configure(model, opts={})
        model.instance_eval do
          self.max_versions = opts[:max_versions] || 10

          one_to_many :internal_versions,
                                   :class => self,
                                   :key => :version_id,
                                   :order => :version_number.desc,
                                   :dependent => :destroy

          many_to_one :parent_version, :class => self, :key => :version_id


          schema_errors = []
          schema_errors << "error: #{self.table_name} must have a version_id column" unless columns.include? :version_id
          schema_errors << "error: #{self.table_name} must have a version_number column" unless columns.include? :version_number
          unless schema_errors.size.zero?
            puts schema_errors.join "\n"
          end
        end
      end


      class NoSuchVersionError < Exception
      end

      #extend ActiveSupport::Concern

      # included do |base|
      # end

      module ClassMethods
        attr_accessor :max_versions

        def last_versions
          self.filter :version_id => nil
        end

        def get_versionable id, version
          self.filter :version_id => id, :version_number => version
        end
      end

      module InstanceMethods
        def after_save
          super
          create_new_version
        end

        def validate
          super
          if !new? && !versionable?
            errors.add :base, "Can't modify versioned record. Use version.editable_version!!"
          end
        end

        def revert_to_version(number)
          version = get_version number
          editable = editable_version
          copy_version_values version, editable
          editable.version_number = nil
          editable.version_id = nil
          editable.save
          editable
        end

        # return a determined version number
        def get_version(number)
          version = versions_dataset.where(:version_number => number).first
          raise NoSuchVersionError if version.nil?
          version
        end

        # return an array with all versions
        def versions_dataset
          if versionable?
            internal_versions_dataset
          else
            self.class.where(:version_id => self.version_id).order(:version_number).reverse
          end
        end

        def versions
          versions_dataset.all
        end

        # check if we are in main version
        def versionable?
          version_id.nil?
        end

        # return the current version
        def version
          return last_version if versionable?
          version_number
        end

        # return the last version number
        def last_version
          return 0 if versions.count == 0
          versions.first.version_number
        end

        # return the last version editable
        def editable_version
          parent_version.nil? ? self : parent_version
        end

        private

        # callback after save
        def create_new_version
          if versionable?

            cloned = copy_version_values self, self.class.new
            cloned.version_id = self.id
            cloned.version_number = last_version + 1
            cloned.save

            # purge max limit
            excess_baggage = cloned.version_number - self.class.max_versions
            if excess_baggage > 0
              versions_dataset.where{ |row| row.version_number <= excess_baggage}.delete
            end
          end
        end

        def copy_version_values(from, to)
          columns = self.class.columns.reject { |c| c == :id }
          columns.each { |c| to.values[c] = from.values[c] }
          to
        end
      end

    end
  end
end
