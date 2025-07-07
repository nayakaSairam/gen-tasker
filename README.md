# 🧠 Elixir Task Manager CLI

A terminal-based task manager built with Elixir GenServer, featuring real-time updates, archiving, editing, and persistent state across sessions.

---

## ✨ Features

✅ Add, edit, delete tasks  
✅ Mark tasks as completed  
✅ View active, completed, pending, or archived tasks  
✅ Archive completed tasks and unarchive them later  
✅ Reset all tasks  
✅ Binary file persistence (`tasks.bin`)  
✅ Interactive CLI via `cli.exs`

---

## 🧱 Tech Stack

- **Elixir** (GenServer, Structs, Pattern Matching)
- File Persistence with `:erlang.term_to_binary/1`
- CLI interface via `IO.gets` & `Pattern Matching`

---

## 📁 Project Structure

task_manager/
├── lib/
│ ├── task_item.ex # Defines %TaskItem{} struct
│ ├── task_server.ex # GenServer logic
│ └── task_manager.ex # Public API
├── cli.exs # Interactive command-line interface
├── tasks.bin # Persistent saved state
├── mix.exs # Mix config
└── README.md

---

## 🚀 Getting Started

### 1️⃣ Clone the repo

```bash
git clone https://github.com/your-username/task_manager.git
cd task_manager
```

### 2️⃣ Run in CLI mode
```bash
elixir cli.exs
```
Or, use IEx with Mix:

```bash
iex -S mix
TaskCLI.run()
```
### 🕹 CLI Options

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

### 🧪 Example Usage
```bash
TaskManager.add("Study Elixir")
TaskManager.mark_done(1)
TaskManager.archive_completed()
TaskManager.unarchive_task(1)
TaskManager.show_all_tasks()
```
### 🧼 Reset All Tasks
```bash
TaskManager.reset_all()
```
---
## 🧠 Notes
1. Tasks are saved in tasks.bin using binary serialization.
2. IDs are auto-incremented and preserved across sessions.
3. Archived tasks are stored separately and can be restored.
---
## 📄 License
This project is licensed under the MIT License.
---
## 🙌 Author
Developed by nayakaSairam






