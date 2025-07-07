# cli.exs
Code.compile_file("lib/task_item.ex")
Code.compile_file("lib/task_server.ex")
Code.compile_file("lib/task_manager.ex")

TaskManager.start()
defmodule TaskCLI do
  def run do
    loop()
  end

  defp loop do
    IO.puts("""
    \n=== TASK MANAGER CLI ===
    1. Add Task
    2. Show Active Tasks
    3. Mark Done
    4. Delete Task
    5. Edit Task
    6. Show Completed
    7. Show Pending
    8. Archive Completed
    9. Show Archived
    10. Unarchive Task
    11. Show All Tasks
    12. Reset All
    0. Exit
    """)
    IO.write("> Choose option: ")
    case IO.gets("") |> String.trim() |> String.to_integer() do
      1 ->
        desc = IO.gets("Task description: ") |> String.trim()
        IO.inspect(TaskManager.add(desc))
        loop()

      2 ->
        IO.inspect(TaskManager.show())
        loop()

      3 ->
        id = get_id()
        IO.inspect(TaskManager.mark_done(id))
        loop()

      4 ->
        id = get_id()
        IO.inspect(TaskManager.delete_task(id))
        loop()

      5 ->
        id = get_id()
        desc = IO.gets("New description: ") |> String.trim()
        IO.inspect(TaskManager.edit_task(id, desc))
        loop()

      6 ->
        IO.inspect(TaskManager.get_completed())
        loop()

      7 ->
        IO.inspect(TaskManager.get_pending())
        loop()

      8 ->
        IO.inspect(TaskManager.archive_completed())
        loop()

      9 ->
        IO.inspect(TaskManager.get_archived())
        loop()

      10 ->
        id = get_id()
        IO.inspect(TaskManager.unarchive_task(id))
        loop()

      11 ->
        IO.inspect(TaskManager.show_all_tasks())
        loop()

      12 ->
        IO.inspect(TaskManager.reset_all())
        loop()

      0 ->
        IO.puts("Exiting... Bye!")
        :ok

      _ ->
        IO.puts("Invalid option.")
        loop()
    end
  end

  defp get_id do
    IO.gets("Enter task ID: ") |> String.trim() |> String.to_integer()
  end
end

TaskCLI.run()
