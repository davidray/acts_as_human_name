$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'active_record/acts/human_name'

ActiveRecord::Base.class_eval { include ActiveRecord::Acts::HumanName }
