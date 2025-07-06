defmodule TaskItem do
  @moduledoc """
  Represents a single task with a descriotion and completion status
  """
  defstruct [:desc, done: false]
end
