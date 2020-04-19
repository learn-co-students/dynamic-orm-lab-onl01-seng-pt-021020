require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'interactive_record.rb'

class Student < InteractiveRecord
    self.column_names.each {|col_name| attr_accessor col_name.to_sym} #goes over the inserted column_names and itterates over them to convert them to a symbol
end

