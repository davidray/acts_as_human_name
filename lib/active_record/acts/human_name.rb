module ActiveRecord
  module Acts #:nodoc:
    module HumanName #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      # This +acts_as+ extension provides the capabilities rendering different representations of a 
      # human name in English. Models need to store last_name, first_name, middle_name, and suffix columns
      # for this plugin to work.
      
      module ClassMethods
        # Configuration options are:
        #
        # * +last_name+ - specifies where the last name is stored (default: +last_name+)
        # * +first_name+ - specifies where the first name is stored (default: +first_name+)
        # * +middle_name+ - specifies where the middle name is stored (default: +middle_name+)
        # * +suffix+ - specifies where the suffix is stored (default: +suffix+)
        #   Example: <tt>acts_as_human_name :last_name => "surname"</tt>
        # HEY!!! This configuration stuff doesn't actually work yet!!!
        def acts_as_human_name(options = {})
          unless included_modules.include? InstanceMethods
            include ActiveRecord::Acts::HumanName::InstanceMethods

            def acts_as_human_name_class
              #{self.name}
            end
          end

          configuration = { :last_name => "last_name", 
                            :first_name => "first_name", 
                            :middle_name => "middle_name",
                            :suffix => "suffix" }
                            
          configuration.update(options) if options.is_a?(Hash)
        end
      end

      module InstanceMethods
        def regular_name
          if first_name and last_name
            "#{self.first_name} #{self.last_name}"
          elsif first_name
            first_name
          elsif last_name
            last_name
          end
        end

        def full_name
          if first_name and last_name and middle_name and suffix
            "#{last_name}, #{first_name} #{middle_name} #{suffix}"
          elsif first_name and last_name and middle_name
            "#{last_name}, #{first_name} #{middle_name}"
          elsif first_name and last_name and suffix
            "#{last_name}, #{first_name} #{suffix}"
          elsif first_name and last_name
            "#{last_name}, #{first_name}"
          elsif last_name
            last_name
          elsif first_name
            first_name
          end
        end
      end 
    end
  end
end
