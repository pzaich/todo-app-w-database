require 'sqlite3'
require './task.rb'

module Todo
  class List
    def initialize(db_filename)
        @tasks = []
        @db = SQLite3::Database.new db_filename

        rows = @db.execute <<-SQL
          create table if not exists tasks (
            id integer primary key autoincrement,
            description varchar(50),
            created_at datetime,
            completed_at datetime default null
          );
        end
        SQL

        @db.execute( "select * from tasks" ) do |row|
          @tasks << Task.from_array(row)
        end

    end

    def list(option = nil)
      case option
      when :complete
        task_list = @tasks.select { |task| task.complete? }.collect{|task| task.task_string}
      when :incomplete
        task_list = @tasks.select { |task| !task.complete? }.collect{|task| task.task_string}
      else
        task_list = @tasks.collect {|task| task.task_string}
      end
    end

    def add(description)
      @db.execute "insert into tasks (description, created_at) values ('#{description}', datetime('now'))"
    end

    def delete(index)
      @db.execute "delete from tasks where description = '#{@tasks[index-1].description}'"
    end

    def complete(index)
      @db.execute "update tasks set completed_at = datetime('now') where description = '#{@tasks[index-1].description}'"
    end
  end
end


