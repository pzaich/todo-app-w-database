require 'sqlite3'
require './list.rb'

module Todo

  class Task
    attr_reader :description
    def initialize(description, created_at = Time.now, completed_at = nil)
      @description = description
      @created_at = created_at
      @completed_at = completed_at
    end

    def self.from_array(row_from_db)
      Task.new(row_from_db[1], row_from_db[2], row_from_db[3])
    end

    def task_string
      "#{@description} | #{@created_at} | #{@completed_at}"
    end

    def complete?
      !@completed_at.nil?
    end

    def complete!
      @completed_at = Time.now
    end

  end
end