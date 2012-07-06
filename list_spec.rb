require 'simplecov'
require 'rspec'
SimpleCov.start
require './list.rb'
include Todo

describe 'Todo::List' do

  context '#initialize' do

    before :each do
      @list = List.new('test.db')
    end

    it 'should create an instance of the class List' do
      @list.should be_an_instance_of List
    end

  end

  context '#add' do
    before :each do
      @list = List.new('test.db')
    end

    after :each do
      @db = SQLite3::Database.new "test.db"
      @db.execute "delete from tasks where description = 'do something'"
    end

    it 'should add Tasks to db and be able to list the item when the database object is reinitialized' do
      @list.add('do something')
      @list = List.new('test.db')
      @list.list[0].should include('do something')
    end
  end

  context '#delete' do
    before :each do
      @list = List.new('test.db')
      @list.add('do something')
    end

    it "should delete the existing task from the database using the array index + 1 from the list" do
      @list = List.new('test.db')
      @list.delete(1)
      @list = List.new('test.db')
      @list.list.should eq []
    end
  end

  context '#complete' do
    before :each do
      @list = List.new('test.db')
      @list.add('do something')
    end

    it 'should complete tasks' do
      @list = List.new('test.db')
      @list.complete(1)
      @list = List.new('test.db')
      @list.list[0].split(' | ')[2].should_not be_nil
    end

    after :each do
      @db = SQLite3::Database.new "test.db"
      @db.execute "delete from tasks where description = 'do something'"
    end
  end

  context '#list' do
    before :each do
      @time_now = Time.now
      Time.stub(:now).and_return(@time_now)

      @db = SQLite3::Database.new "test.db"
      @db.execute "insert into tasks (description, created_at) values ('wash pet elephant', '#{Time.now.to_s}')"
      @db.execute "insert into tasks (description, created_at, completed_at) values ('wash pet elephant', '#{Time.now.to_s}', '#{Time.now.to_s}')"
      @list = List.new('test.db')
    end

    after :each do
      @db.execute "delete from tasks where description = 'wash pet elephant'"
    end

    it 'should return list of all tasks' do
      @list.list.should eq(["wash pet elephant | #{Time.now.to_s} | ", "wash pet elephant | #{Time.now.to_s} | #{Time.now.to_s}"])
    end

    it 'should return the complete tasks when passed a :complete symbol' do
      @list.list(:complete).should eq(["wash pet elephant | #{Time.now.to_s} | #{Time.now.to_s}"])
    end

    it 'should return the incomplete tasks when passed a :incomplete symbol' do
      @list.list(:incomplete).should eq(["wash pet elephant | #{Time.now.to_s} | "])
    end
  end

end

