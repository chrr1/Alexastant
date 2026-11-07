class TodayTaskItem {
  final String id;
  final String title;
  final String matkul;
  final String due;
  bool isCompleted;

  TodayTaskItem({
    required this.id,
    required this.title,
    required this.matkul,
    required this.due,
    this.isCompleted = false,
  });
}

