require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",completed: Time.now + 5.days
  }

  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path

      # Assert
      must_respond_with :success
    end

    it "can get the root path" do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end

  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid task" do
      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "can get the new task page" do

      # Act
      get new_task_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new task" do

      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completed: nil,
        },
      }

      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1

      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed).must_equal task_hash[:task][:completed]

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end

  describe "edit" do
    it "can get the edit page for an existing task" do
      get edit_task_path(task.id)
      must_respond_with :success
    end

    it "will respond with redirect when attempting to edit a nonexistant task" do
      get edit_task_path(-1)

      must_respond_with :redirect
    end
  end

  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great thing to test.

    let(:updates) {
      {
      task: {
        name: "Updated name",
        description: 'Updated description'
      }
    }
  }
  
    it "can update an existing task" do
      patch task_path(task.id), params: updates
      
      updated_task = Task.find_by(id: task.id)
      expect(updated_task.name).must_equal updates[:task][:name]
      expect(updated_task.description).must_equal updates[:task][:description]


      must_respond_with :redirect
      must_redirect_to task_path(updated_task.id)
    end


    it "will redirect to the root page if given an invalid id" do
      patch task_path(-1), params: updates

      must_respond_with :redirect
    end
  end

  describe "destroy" do
    it "can destroy an existing task" do
      Task.create(name: "New Task", description: "New Description")
      task_id = Task.find_by(name: "New Task").id

      expect {
        delete task_path(task_id)
      }.must_differ "Task.count", -1

      must_respond_with :redirect
    end

    it "will redirect to the root page if given an invalid id" do
      expect {
        delete task_path(-1)
      }.must_differ "Task.count", 0

      must_respond_with :redirect
    end

  end

  
  describe "toggle_complete" do
    it "can update an existing task as completed(value=time selected)" do
      new_task = Task.create(name: "New Task", description: "New Description")
      new_task_id = new_task.id
      
      get complete_task_path(new_task_id)
    
      must_respond_with :redirect
      expect(new_task.completed).wont_equal nil
    end
    
    it "will redirect to the root page if given an invalid id" do
      get complete_task_path(-1)
      
      must_respond_with :redirect
    end

  end
  describe "toggle_uncomplete" do
    it "can update an existing task as uncompleted(value=nil)" do      
      get uncomplete_task_path(task.id)
    
      must_respond_with :redirect
      expect(task.completed).must_equal nil
    end
    
    it "will redirect to the root page if given an invalid id" do
      get uncomplete_task_path(-1)
      
      must_respond_with :redirect
    end
  end
end