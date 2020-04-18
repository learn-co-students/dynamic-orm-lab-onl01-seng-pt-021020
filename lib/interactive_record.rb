require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def self.table_name #this method calls self (which is the name) then converts it to a string. This allows itslef to be added to collumns and rows
    self.to_s.downcase.pluralize 
  end

  def self.column_names #PRAGMA calls the data, then we go into the data and pull the name of the columns.
    sql = "PRAGMA table_info('#{table_name}')" #calls PRAGMA on the table_name 
    DB[:conn].execute(sql).collect {|hash| hash["name"]} #creates new array using collect and takes the hash["name"]
  end

  def initialize(attributes={}) #this assigns the attr_accessor to the class. Takes in a hash
    attributes.each {|k, v| self.send("#{k}=", v)} 
  end

  def table_name_for_insert #return the table name when called on an instance 
    self.class.table_name
  end 

  def col_names_for_insert
    self.class.column_names.delete_if {|col| col == "id"}.join(", ") #goes over the column_column names method returns the name
                                                                     #but deletes the id (as that is added when in the table)
  end

  def values_for_insert
    values = []
    self.class.column_names.each do |column_name|
      values << "'#{send(column_name)}'" unless send(column_name).nil?
    end
    values.join(", ")
  end

  def save
    sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert}) " #this takes our methods and passes them into 
                                                                                                          #the SQL Query so that no matter what data we use, it will work 
    DB[:conn].execute(sql) #executes the SQL query
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0] #sets the @id = to the last inserted ID
  end

  def self.find_by_name(name) #receives names as an arguemnet 
    sql = "SELECT * FROM #{self.table_name} WHERE name = '#{name}'"  #creates SQL statement that takes in the table name and adds the name
    DB[:conn].execute(sql)
  end

  def self.find_by(attributes) #takes in a hash key/value ({:name=> "Susan"})
    column = attributes.keys[0].to_s #converts the key to a string = "name"
    value = attributes.values[0].to_s #converts the value into a string = "Susan"
    sql = "SELECT * FROM #{self.table_name} WHERE #{column} = '#{value}'" #passes in the column and value
    DB[:conn].execute(sql)
  end
  
end