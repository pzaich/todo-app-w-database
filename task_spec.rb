require 'simplecov'
require 'rspec'
SimpleCov.start
require './task.rb'
include Todo

describe 'Todo::Task' do
  context '#initialize' do
    before :each do
      @task = Task.new("description of task")
    end
    it 'should create an instance of the class task' do
      @task.should be_an_instance_of Task
    end

  end

  context '#task_string' do
    before :each do
      @this_time = Time.now
      @completed_time = Time.now + 100
      @task = Task.new("description of task")
      @task2 = Task.new("description of task", @this_time, @completed_time)
    end

    it "should return a string that created_at" do
      @task.task_string.should include(@this_time.to_s)
    end

    it "should return a string that includes the description" do
      @task.task_string.should include("description of task")
    end

    it "should return a string that includes completed_at time" do
      @task2.task_string.should include(@completed_time.to_s)
    end
  end

  context '#from_array' do
    before :each do
      @this_time = Time.now
      @completed_time = Time.now + 100
    end
    it 'should be an instance of Task' do
      Task.from_array([1, "description of task", @this_time, @completed_time]).should be_an_instance_of Task
    end
    it 'should take params from array' do
      Task.from_array([1, "description of task", @this_time, @completed_time]).task_string.should eq ("description of task | #{@this_time} | #{@completed_time}")
    end
  end

  context '#complete' do
    before :each do
      @time_stub = Time.now
      Time.stub(:now).and_return(@time_stub)
      @task = Task.new("Description of task")
    end

    it 'should check completeness' do
      @task.complete?.should eq false
    end

    it 'complete! should complete task' do
      @task.complete!
      @task.complete?.should eq true
    end

    it 'should return the correct complete time' do
      @time_stub += 100
      Time.stub(:now).and_return(@time_stub)
      @task.complete!
      @task.task_string.should include @time_stub.to_s
    end
  end

end