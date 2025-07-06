alias TaskItem

defmodule TaskServer do
  use GenServer
  @save_file "tasks.bin"

  defp persist(state) do
    binary=:erlang.term_to_binary(state)
    File.write!(@save_file,binary)
  end

  #Client API
  def start_link(_opts) do
    GenServer.start_link(__MODULE__,%{},name: __MODULE__)
  end

  def add_task(task_description) do
    GenServer.call(__MODULE__, {:add_task, task_description})
  end

  def get_tasks do
    GenServer.call(__MODULE__, :get_tasks)
  end


  def mark_done(task_id) do
    GenServer.call(__MODULE__,{:mark_done, task_id})
  end

  def delete_task(task_id) do
    GenServer.call(__MODULE__,{:delete_task,task_id})
  end

  def get_completed do
  GenServer.call(__MODULE__, :get_completed)
end

def get_pending do
  GenServer.call(__MODULE__, :get_pending)
end

def edit_task(task_id, new_description) do
  GenServer.call(__MODULE__,{:edit_task, task_id, new_description})
end

def reset_all do
  GenServer.call(__MODULE__, :reset_all)
end

  #Server Callbacks


  def init(_args) do
    state =
      case File.read(@save_file) do
        {:ok,binary}-> :erlang.binary_to_term(binary)
        _->%{}
      end
    IO.puts("TaskServer is online with loaded tasks.")
    {:ok,state}
  end

  def handle_call({:add_task, task_description},_from,state) do
    task_id = map_size(state) + 1
    new_task= %TaskItem{desc: task_description}
    new_state = Map.put(state, task_id, new_task)
    persist(new_state)
    {:reply, {:ok, task_id}, new_state}
  end

    def handle_call(:get_tasks, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:mark_done, task_id}, _from, state) do
    case Map.get(state, task_id) do
      nil ->
        {:reply,{:error, :not_found},state}

      task ->
        updated_task= %{task | done: true}
        new_state = Map.put(state, task_id, updated_task)
        persist(new_state)
        {:reply,{:ok,task_id}, new_state}
    end
  end

  def handle_call({:delete_task,task_id},_from, state) do
    case Map.has_key?(state,task_id) do
      true->
        new_state=Map.delete(state,task_id)
        persist(new_state)
        {:reply,:ok,new_state};
      false->
        {:reply,{:error,:not_found},state}
    end
  end

  def handle_call(:get_completed, _from, state) do
  completed = Enum.filter(state, fn {_id, task} -> task.done == true end)
  {:reply, Map.new(completed), state}
  end

  def handle_call(:get_pending, _from, state) do
  pending = Enum.filter(state, fn {_id, task} -> task.done == false end)
  {:reply, Map.new(pending), state}
  end

  def handle_call({:edit_task, task_id,new_desc}, _from, state) do
    case Map.get(state,task_id) do
      nil->
        {:reply,{:error,:not_found},state}
    %TaskItem{}= task->
      updated_task=%TaskItem{task | desc: new_desc}
      new_state=Map.put(state,task_id,updated_task)
      persist(new_state)
      {:reply, {:ok,task_id},new_state}
    end
  end

  def handle_call(:reset_all, _from, _state) do
    new_state=%{}
    persist(new_state)
    {:reply, :ok, new_state}
  end
  
end
