defmodule TaskManager do
  def start do
    TaskServer.start_link([])
  end
  def add(task),do: TaskServer.add_task(task)

  def show,do: TaskServer.get_tasks()

  def mark_done(task_id),do: TaskServer.mark_done(task_id)

  def delete_task(task_id),do: TaskServer.delete_task(task_id)

  def get_completed,do: TaskServer.get_completed()

  def get_pending,do: TaskServer.get_pending()

  def edit_task(task_id,new_description),do: TaskServer.edit_task(task_id, new_description)

  def archive_completed, do: TaskServer.archieve_completed()

  def get_archived, do: TaskServer.get_archived()

  def unarchive_task(id), do: TaskServer.unarchive_task(id)

  def show_all_tasks, do: TaskServer.show_all_tasks()

  def reset_all,do: TaskServer.reset_all()

end
