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

def archieve_completed do
  GenServer.call(__MODULE__, :archive_completed)
end

def get_archived do
  GenServer.call(__MODULE__, :get_archived)
end

def reset_all do
  GenServer.call(__MODULE__, :reset_all)
end

  #Server Callbacks


  def init(_args) do
    state =
      case File.read(@save_file) do
        {:ok,binary}-> :erlang.binary_to_term(binary)
        _->%{active: %{}, archived: %{}}
      end
    IO.puts("TaskServer is online with loaded tasks.")
    {:ok,state}
  end

  def handle_call({:add_task, task_description},_from,%{active: active, archived: archived} = _state) do
    task_id = map_size(active) + 1
    new_task= %TaskItem{desc: task_description}
    new_state = %{active: Map.put(active, task_id, new_task),archived: archived}
    persist(new_state)
    {:reply, {:ok, task_id}, new_state}
  end

  def handle_call(:get_tasks, _from, %{active: active} = state) do
  {:reply, active, state}
  end

  def handle_call({:mark_done, task_id}, _from, %{active: active, archived: archived} = state) do
    case Map.get(active, task_id) do
      nil ->
        {:reply,{:error, :not_found},state}

      task ->
        updated_task= %{task | done: true}
        new_state = %{active: Map.put(active, task_id, updated_task),archived: archived}
        persist(new_state)
        {:reply,{:ok,task_id}, new_state}
    end
  end

  def handle_call({:delete_task,task_id},_from, %{active: active, archived: archived} = state) do
    case Map.has_key?(active,task_id) do
      true->
        new_active=Map.delete(active,task_id)
        new_state= %{active: new_active, archived: archived}
        persist(new_state)
        {:reply,:ok,new_state};
      false->
        {:reply,{:error,:not_found},state}
    end
  end

  def handle_call(:get_completed, _from, %{active: active, archived: _archived} = state) do
  completed = Enum.filter(active, fn {_id, task} -> task.done == true end)
  {:reply, Map.new(completed), state}
  end

  def handle_call(:get_pending, _from, %{active: active, archived: _archived} = state) do
  pending = Enum.filter(active, fn {_id, task} -> task.done == false end)
  {:reply, Map.new(pending), state}
  end

  def handle_call({:edit_task, task_id,new_desc}, _from, %{active: active, archived: archived} = state) do
    case Map.get(active,task_id) do
      nil->
        {:reply,{:error,:not_found},state}

      %TaskItem{}= task->
      updated_task=%TaskItem{task | desc: new_desc}
      new_active=Map.put(active,task_id,updated_task)
      new_state=%{active: new_active, archived: archived}
      persist(new_state)
      {:reply, {:ok,task_id},new_state}
    end
  end

  def handle_call(:archive_completed,_from,%{active: active, archived: archived} ) do
    {to_archive, still_active} = Enum.split_with(active, fn{_id,task}-> task.done end)
    new_archived = Map.merge(archived, Map.new(to_archive))
    new_state = %{active: Map.new(still_active),archived: new_archived}
    persist(new_state)
    {:reply, :ok, new_state}
  end

  def handle_call(:get_archived, _from, state) do
  {:reply, state.archived, state}
  end

  def handle_call(:reset_all, _from, _state) do
    new_state=%{active: %{},archived: %{}}
    persist(new_state)
    {:reply, :ok, new_state}
  end

end
