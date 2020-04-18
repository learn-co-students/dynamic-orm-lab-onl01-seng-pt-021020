require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'interactive_record.rb'

class Student < InteractiveRecord
  
  self.column_names.each do |column_name|
    attr_accessor column_name.to_sym
  end 
end

#The only code the Student class needs to contain is the code to create the attr_accessors specific to itself. But even that code uses a method, #column_names, inherited from the super class.