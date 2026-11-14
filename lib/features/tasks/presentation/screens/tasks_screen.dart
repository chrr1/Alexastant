import 'package:flutter/material.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../domain/models/task_model.dart';
import '../widgets/full_month_calendar_modal.dart';
import '../widgets/minimal_task_header.dart';
import '../widgets/minimal_week_strip.dart';
import '../widgets/modals/task_crud_modal.dart';
import '../widgets/unified_task_glass_shell.dart';

// Re-export for backward compatibility
export '../../domain/models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  // ── Theme animation ────────────────────────────────────────────────────────
  AnimationController? _themeController;
  Animation<double>? _themeAnim;

  void _ensureThemeInitialized() {
    if (_themeController != null) return;
    _themeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: ThemeController.instance.isDarkMode ? 0.0 : 1.0,
    );
    _themeAnim = CurvedAnimation(
      parent: _themeController!,
      curve: Curves.easeInOutQuart,
    );
  }

  void _onThemeChanged() {
    _ensureThemeInitialized();
    if (ThemeController.instance.isDarkMode) {
      _themeController?.reverse();
    } else {
      _themeController?.forward();
    }
  }

  // ── Selected Date & Week Strip ─────────────────────────────────────────────
  DateTime _currentSelectedDate = DateTime.now();
  int _selectedDayIndex = 0;
  List<WeekDayItem> _weekDays = [];

  void _generateWeekDays(DateTime anchorDate) {
    final startOfWeek = anchorDate.subtract(Duration(days: anchorDate.weekday - 1));
    const dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    _weekDays = List.generate(7, (i) {
      final date = startOfWeek.add(Duration(days: i));
      return WeekDayItem(
        dayLetter: dayLetters[i],
        dateNumber: date.day,
        date: date,
      );
    });

    _selectedDayIndex = (anchorDate.weekday - 1).clamp(0, 6);
  }

  // ── Tasks Data with Subtasks (Opsi A) ──────────────────────────────────────
  late final List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      title: 'Study Typography Fundamentals',
      description:
          'Learn about font pairing, hierarchy, and readability. Complete the typography exercise in your design workbook.',
      workspace: 'Desain',
      matkul: 'Desain Komunikasi Visual',
      priority: TaskPriority.urgent,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().copyWith(hour: 17, minute: 0),
      isFocus: true,
      estimatedHours: 2,
      subtasks: [
        SubtaskItem(
          id: 's1',
          title: 'Baca panduan Font Pairing & Type Scale',
          isCompleted: true,
        ),
        SubtaskItem(
          id: 's2',
          title: 'Kerjakan eksperimen hierarchy di Figma',
          isCompleted: false,
        ),
        SubtaskItem(
          id: 's3',
          title: 'Export hasil eksplorasi ke format PDF',
          isCompleted: false,
        ),
      ],
    ),
    TaskModel(
      id: '2',
      title: 'Create a Type Specimen Poster',
      description:
          'Eksplorasi layout grid dan kontras tipografi untuk poster pameran desain akhir semester.',
      workspace: 'Desain',
      matkul: 'Desain Komunikasi Visual',
      priority: TaskPriority.high,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 1)).copyWith(hour: 20, minute: 0),
      estimatedHours: 3,
      subtasks: [
        SubtaskItem(
          id: 's4',
          title: 'Tentukan 2 font kontras (Serif & Sans)',
          isCompleted: true,
        ),
        SubtaskItem(
          id: 's5',
          title: 'Susun layout poster di kertas sketsa',
          isCompleted: false,
        ),
      ],
    ),
    TaskModel(
      id: '3',
      title: 'Siapkan Dokumen SRS & Use Case Diagram',
      description:
          'Konfirmasi ruang lingkup modul asisten suara dan siapkan diagram relasi.',
      workspace: 'Kuliah',
      matkul: 'Rekayasa Perangkat Lunak',
      priority: TaskPriority.urgent,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().copyWith(hour: 15, minute: 30),
      estimatedHours: 2,
      subtasks: [
        SubtaskItem(
          id: 's6',
          title: 'Tulis Functional Requirements Modul 1-4',
          isCompleted: true,
        ),
        SubtaskItem(
          id: 's7',
          title: 'Buat Use Case Diagram di PlantUML',
          isCompleted: true,
        ),
      ],
    ),
    TaskModel(
      id: '4',
      title: 'Normalisasi Database 3NF & Schema DDL',
      description:
          'Rancang tabel tasks, notes, users dan relasi foreign key untuk Supabase.',
      workspace: 'Kuliah',
      matkul: 'Basis Data',
      priority: TaskPriority.high,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 2)).copyWith(hour: 23, minute: 59),
      estimatedHours: 2,
      subtasks: [
        SubtaskItem(
          id: 's8',
          title: 'Tentukan Primary Key & Foreign Key tiap tabel',
          isCompleted: false,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ensureThemeInitialized();
    ThemeController.instance.addListener(_onThemeChanged);
    _generateWeekDays(_currentSelectedDate);
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    _themeController?.dispose();
    super.dispose();
  }

  void _toggleSubtask(TaskModel task, SubtaskItem subtask) {
    setState(() {
      subtask.isCompleted = !subtask.isCompleted;
      // Auto-update task status if all subtasks completed
      if (task.subtasks.every((s) => s.isCompleted)) {
        task.status = TaskStatus.completed;
      } else if (task.status == TaskStatus.completed) {
        task.status = TaskStatus.inProgress;
      }
    });
  }

  void _toggleTaskComplete(TaskModel task) {
    setState(() {
      final isNowCompleted = task.status != TaskStatus.completed;
      task.status = isNowCompleted ? TaskStatus.completed : TaskStatus.inProgress;
      for (var s in task.subtasks) {
        s.isCompleted = isNowCompleted;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.status == TaskStatus.completed
                    ? 'Tugas selesai! 🎉 Kerja bagus.'
                    : 'Tugas ditandai belum selesai.',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openFullMonthCalendar() {
    final isDark = ThemeController.instance.isDarkMode;
    FullMonthCalendarModal.show(
      context: context,
      isDark: isDark,
      initialSelectedDate: _currentSelectedDate,
      taskDays: {2, 3, 4, 7, 12, 18, 24},
      onDateSelected: (newDate) {
        setState(() {
          _currentSelectedDate = newDate;
          _generateWeekDays(newDate);
        });
      },
    );
  }

  void _openCreateTaskModal() {
    final isDark = ThemeController.instance.isDarkMode;
    TaskCrudModal.show(
      context: context,
      isDark: isDark,
      onSave: (newTask) {
        setState(() {
          _tasks.insert(0, newTask);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas baru berhasil ditambahkan! 🚀'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF0F172A),
          ),
        );
      },
    );
  }

  void _openEditTaskModal(TaskModel task) {
    final isDark = ThemeController.instance.isDarkMode;
    TaskCrudModal.show(
      context: context,
      isDark: isDark,
      taskToEdit: task,
      onSave: (updatedTask) {
        setState(() {
          final idx = _tasks.indexWhere((t) => t.id == updatedTask.id);
          if (idx != -1) {
            _tasks[idx] = updatedTask;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perubahan tugas berhasil disimpan! ✨'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF0F172A),
          ),
        );
      },
      onDelete: (taskId) {
        setState(() {
          _tasks.removeWhere((t) => t.id == taskId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil dihapus.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _ensureThemeInitialized();

    return AnimatedBuilder(
      animation: _themeAnim!,
      builder: (context, _) {
        final t = _themeAnim!.value;
        final isDark = t < 0.5;

        // Calculate progress percentage
        final completedCount = _tasks.where((t) => t.status == TaskStatus.completed).length;
        final progressPercent = _tasks.isNotEmpty
            ? ((completedCount / _tasks.length) * 100).toInt()
            : 35;
        final displayProgress = progressPercent == 0 ? 35 : progressPercent;

        // ── Atmospheric Gradient ─────────────────────────────────
        
final bgDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: const Alignment(-1.0, -1.0),
    end: const Alignment(1.0, 0.9),
    colors: [
      Color.lerp(
        const Color(0xFF080A12),
        const Color(0xFF6899AD),
        t,
      )!,
      Color.lerp(
        const Color(0xFF17213A),
        const Color(0xFF657DAF),
        t,
      )!,
      Color.lerp(
        const Color(0xFF526FAF),
        const Color(0xFFD6E2EC),
        t,
      )!,
      Color.lerp(
        const Color(0xFFF0EFF4),
        const Color(0xFFF4F3F6),
        t,
      )!,
    ],
    stops: const [0.0, 0.38, 0.68, 1.0],
  ),
);

        // Date calculations for week strip
        final selectedDay = _weekDays[_selectedDayIndex];
        const monthNames = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        final monthName = monthNames[selectedDay.date.month - 1];

        // Week range text
        final firstDate = _weekDays.first.dateNumber;
        final lastDate = _weekDays.last.dateNumber;
        final weekRangeText = '$monthName $firstDate-$lastDate';

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: bgDecoration,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 14),

                          // ─── 1. Header: Add Button only
                          MinimalTaskHeader(
                            isDark: isDark,
                            onAddTask: _openCreateTaskModal,
                          ),

                          const SizedBox(height: 20),

                          // ─── 2. MEGA FROSTED GLASS SHELL ────────────────────
                          // Inside:
                          // - Overall progress (top)
                          // - STACKED TASK CARDS SLIDER (with Subtasks Checklist & Deadline + Edit)
                          // - This Week 7-Day Calendar Strip + Month Popup
                          UnifiedTaskGlassShell(
                            isDark: isDark,
                            tasks: _tasks,
                            progressPercent: displayProgress,
                            weekDays: _weekDays,
                            selectedDayIndex: _selectedDayIndex,
                            weekRangeText: weekRangeText,
                            onToggleTaskComplete: _toggleTaskComplete,
                            onToggleSubtask: _toggleSubtask,
                            onEditTask: _openEditTaskModal,
                            onMonthCalendarTap: _openFullMonthCalendar,
                            onDaySelected: (idx) {
                              setState(() {
                                _selectedDayIndex = idx;
                                _currentSelectedDate = _weekDays[idx].date;
                              });
                            },
                          ),

                          const SizedBox(height: 120), // Bottom padding for navigation bar
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
