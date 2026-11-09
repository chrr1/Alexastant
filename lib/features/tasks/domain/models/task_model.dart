enum TaskPriority { low, medium, high, urgent }

enum TaskStatus { todo, inProgress, completed }

enum TasksViewMode { bentoWorkspaces, kanban, allList }

class SubtaskItem {
  final String id;
  final String title;
  bool isCompleted;

  SubtaskItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String workspace;
  final String? matkul;
  final TaskPriority priority;
  TaskStatus status;
  DateTime? dueDate;
  final int subtasksTotal;
  int subtasksDone;
  final List<String> tags;
  final bool isFocus;
  final int estimatedHours;
  List<SubtaskItem> subtasks;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.workspace,
    this.matkul,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    this.dueDate,
    this.subtasksTotal = 0,
    this.subtasksDone = 0,
    this.tags = const [],
    this.isFocus = false,
    this.estimatedHours = 2,
    List<SubtaskItem>? subtasks,
  }) : subtasks = subtasks ?? [];

  int get totalSubtasksCount => subtasks.isNotEmpty ? subtasks.length : subtasksTotal;
  int get doneSubtasksCount => subtasks.isNotEmpty
      ? subtasks.where((s) => s.isCompleted).length
      : subtasksDone;
}

typedef TaskItemModel = TaskModel;

