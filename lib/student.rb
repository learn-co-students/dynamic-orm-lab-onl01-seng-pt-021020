require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'interactive_record.rb'

require 'pry'

class Student < InteractiveRecord
  # class methods
  def self.table_name
    self.to_s.downcase.pluralize
  end
  
  def self.column_names
    table_info = DB[:conn].execute("PRAGMA table_info(#{table_name})")
    table_info.collect {|column_hash| column_hash['name']}
  end
  
  # pre-processing
  column_names.each {|col_name| attr_accessor col_name.to_sym}
  
  
  # instance methods
  def initialize(attributes={})
    attributes.each {|attribute, value| self.send("#{attribute}=", value)}
    
    self
  end
  
  def col_names_for_insert
    column_names = self.class.column_names
    column_names.delete_if {|column_name| column_name == 'id'}
    column_names.join(', ')
  end
  
  def save
    
  end
  
  def table_name_for_insert
    self.class.table_name
  end
  
  def values_for_insert
    col_names_for_insert.split(', ').collect {|col_name| "'" + self.send("#{col_name}").to_s + "'"}.join(', ')
  end

end
