import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum TaskPriority { low, medium, high, urgent }
enum TaskStatus { todo, inProgress, completed }
enum TasksViewMode { bentoWorkspaces, kanban, allList }

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String workspace;
  final TaskPriority priority;
  TaskStatus status;
  final DateTime? dueDate;
  final int subtasksTotal;
  int subtasksDone;
  final List<String> tags;
  final bool isFocus;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.workspace,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    this.dueDate,
    this.subtasksTotal = 0,
    this.subtasksDone = 0,
    this.tags = const [],
    this.isFocus = false,
  });
}

typedef TaskItemModel = TaskModel;

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TasksViewMode _viewMode = TasksViewMode.bentoWorkspaces;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      title: 'Hubungi klien PT Maju & Siapkan Evaluasi',
      description: 'Konfirmasi agenda evaluasi jam 14:00 dan kirimkan ringkasan materi KPI.',
      workspace: 'Proyek Kuliah',
      priority: TaskPriority.urgent,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(hours: 1)),
      subtasksTotal: 3,
      subtasksDone: 2,
      tags: ['Client', 'Urgent'],
      isFocus: true,
    ),
    TaskModel(
      id: '2',
      title: 'Buat mockup homepage Alexa Mobile',
      description: 'Desain high-fidelity sesuai referensi Figma dan pastikan responsif.',
      workspace: 'Proyek Kuliah',
      priority: TaskPriority.urgent,
      status: TaskStatus.completed,
      dueDate: DateTime.now(),
      subtasksTotal: 4,
      subtasksDone: 4,
      tags: ['Design', 'Figma'],
    ),
    TaskModel(
      id: '3',
      title: 'Implementasi Bottom Navigation & Sub-Halaman',
      description: 'Pisahkan mode timeline jam fullscreen dan sambungkan ke kalender.',
      workspace: 'Proyek Kuliah',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(hours: 3)),
      subtasksTotal: 3,
      subtasksDone: 2,
      tags: ['Flutter', 'Mobile'],
    ),
    TaskModel(
      id: '4',
      title: 'Integrasi Gemini API Tool Calling',
      description: 'Buat handler function calling di backend FastAPI untuk create_task dan create_event.',
      workspace: 'Tugas Harian',
      priority: TaskPriority.high,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      subtasksTotal: 5,
      subtasksDone: 1,
      tags: ['Backend', 'AI'],
    ),
    TaskModel(
      id: '5',
      title: 'Setup Supabase pgvector & Indeks ivfflat',
      description: 'Aktifkan ekstensi vector dan siapkan embedding untuk RAG catatan.',
      workspace: 'Tugas Harian',
      priority: TaskPriority.medium,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      subtasksTotal: 2,
      subtasksDone: 0,
      tags: ['Database', 'pgvector'],
    ),
    TaskModel(
      id: '6',
      title: 'Olahraga Pagi & Meditasi',
      description: 'Lari pagi 3 km dan peregangan ringan.',
      workspace: 'Pribadi',
      priority: TaskPriority.low,
      status: TaskStatus.completed,
      dueDate: DateTime.now(),
      subtasksTotal: 2,
      subtasksDone: 2,
      tags: ['Health'],
    ),
    TaskModel(
      id: '7',
      title: 'Baca Buku Atomic Habits (Bab 4)',
      description: 'Ringkas poin penting ke modul notes Alexa.',
      workspace: 'Pribadi',
      priority: TaskPriority.medium,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      subtasksTotal: 1,
      subtasksDone: 0,
      tags: ['Study', 'Book'],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TaskModel> get _filteredTasks {
    if (_searchQuery.isEmpty) return _tasks;
    final q = _searchQuery.toLowerCase();
    return _tasks.where((t) {
      return t.title.toLowerCase().contains(q) ||
          (t.description?.toLowerCase().contains(q) ?? false) ||
          t.workspace.toLowerCase().contains(q) ||
          t.tags.any((tag) => tag.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((t) => t.status == TaskStatus.completed).length;
    final totalCount = _tasks.length;
    final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;
    final focusTask = _tasks.firstWhere(
      (t) => t.isFocus && t.status != TaskStatus.completed,
      orElse: () => _tasks.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildTopHeader(),
              const SizedBox(height: 16),
              _buildHeroFocusCard(focusTask),
              const SizedBox(height: 14),
              _buildAlexaInsightBanner(),
              const SizedBox(height: 16),
              _buildStatsSummaryRow(completedCount, totalCount, progress),
              const SizedBox(height: 18),
              _buildViewModeSwitcher(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 18),
              if (_viewMode == TasksViewMode.bentoWorkspaces)
                _buildBentoWorkspacesView()
              else if (_viewMode == TasksViewMode.kanban)
                _buildKanbanView()
              else
                _buildAllListView(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildAddFab(),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Tugas & Proyek',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Senin, 02 November 2026',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ],
    );
  }

  // ─── 1. Hero Focus Card ("Focus of the Day") ───────────────────────────────
  Widget _buildHeroFocusCard(TaskModel task) {
    final isDone = task.status == TaskStatus.completed;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1F1F26),
            const Color(0xFF16161C),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.primaryOrange.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryOrangeGlow,
            blurRadius: 22,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrangeSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.star_rounded, size: 14, color: AppColors.primaryOrangeLight),
                    SizedBox(width: 4),
                    Text(
                      'FOKUS UTAMA HARI INI',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryOrangeLight,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Sisa 1 jam lagi',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryOrangeLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDone ? AppColors.textMuted : AppColors.textPrimary,
              decoration: isDone ? TextDecoration.lineThrough : null,
              height: 1.3,
            ),
          ),
          if (task.description != null) ...[
            const SizedBox(height: 6),
            Text(
              task.description!,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 14),
          // Sub-tasks micro progress bar
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sub-tugas (${task.subtasksDone}/${task.subtasksTotal})',
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                        Text(
                          '${((task.subtasksDone / task.subtasksTotal) * 100).toInt()}%',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: task.subtasksTotal > 0 ? (task.subtasksDone / task.subtasksTotal) : 0,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.timer_outlined, size: 16, color: AppColors.textPrimary),
                      SizedBox(width: 6),
                      Text(
                        'Pomodoro (25m)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    task.status = isDone ? TaskStatus.inProgress : TaskStatus.completed;
                    if (task.status == TaskStatus.completed) {
                      task.subtasksDone = task.subtasksTotal;
                    }
                  });
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: isDone ? null : AppColors.orangeGradient,
                    color: isDone ? AppColors.success : null,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(isDone ? Icons.check : Icons.check_circle_outline, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        isDone ? 'Selesai' : 'Tandai Selesai',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── 2. Alexa Smart AI Insight Banner ─────────────────────────────────────
  Widget _buildAlexaInsightBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryOrange.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.orangeGradient,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                children: [
                  TextSpan(text: 'Saran Alexa: ', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryOrangeLight)),
                  TextSpan(
                    text: 'Selesaikan tugas klien PT Maju sebelum jam 14:00 karena ada agenda evaluasi meeting offline setelahnya.',
                    style: TextStyle(color: Color(0xFFD1D5DB)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 3. Stats Summary with Circular Ring ──────────────────────────────────
  Widget _buildStatsSummaryRow(int completed, int total, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Circular progress ring
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$completed dari $total Tugas Selesai',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    '2 tugas berprioritas mendesak',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryOrangeSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Hari Ini',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryOrangeLight),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 4. View Mode Switcher (Bento Workspaces, Kanban, All List) ─────────────
  Widget _buildViewModeSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _buildViewModeButton('Bento Proyek', TasksViewMode.bentoWorkspaces, Icons.grid_view_rounded),
          _buildViewModeButton('Kanban Board', TasksViewMode.kanban, Icons.view_column_rounded),
          _buildViewModeButton('Daftar Semua', TasksViewMode.allList, Icons.format_list_bulleted_rounded),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(String title, TasksViewMode mode, IconData icon) {
    final isSelected = _viewMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _viewMode = mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryOrange : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: AppColors.primaryOrangeGlow,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: isSelected ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Search Bar ───────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Cari tugas, tag, atau workspace...',
                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 18),
            ),
        ],
      ),
    );
  }

  // ─── VIEW 1: Bento Workspace Cards ─────────────────────────────────────────
  Widget _buildBentoWorkspacesView() {
    final workspaces = ['Proyek Kuliah', 'Tugas Harian', 'Pribadi'];

    return Column(
      children: workspaces.map((ws) {
        final tasks = _filteredTasks.where((t) => t.workspace == ws).toList();
        if (tasks.isEmpty) return const SizedBox.shrink();

        final done = tasks.where((t) => t.status == TaskStatus.completed).length;
        final total = tasks.length;
        final wsProgress = total > 0 ? (done / total) : 0.0;
        final isOrangeCard = ws == 'Tugas Harian';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: isOrangeCard ? AppColors.orangeGradient : null,
            color: isOrangeCard ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: isOrangeCard ? Colors.transparent : AppColors.cardBorder),
            boxShadow: isOrangeCard
                ? const [
                    BoxShadow(
                      color: AppColors.primaryOrangeGlow,
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    )
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Workspace Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isOrangeCard ? Colors.white.withOpacity(0.2) : AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isOrangeCard ? Icons.workspaces_rounded : Icons.folder_open_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ws,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isOrangeCard ? Colors.white.withOpacity(0.2) : AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$done/$total selesai',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: wsProgress,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOrangeCard ? Colors.white : AppColors.primaryOrange,
                  ),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 14),
              // Task Items inside this workspace
              ...tasks.map((task) => _buildBentoTaskItem(task, isOrangeCard)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBentoTaskItem(TaskModel task, bool onOrangeBackground) {
    final isDone = task.status == TaskStatus.completed;

    return GestureDetector(
      onTap: () {
        setState(() {
          task.status = isDone ? TaskStatus.inProgress : TaskStatus.completed;
          if (task.status == TaskStatus.completed) {
            task.subtasksDone = task.subtasksTotal;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: onOrangeBackground ? Colors.black.withOpacity(0.15) : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: onOrangeBackground ? Colors.white.withOpacity(0.1) : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? (onOrangeBackground ? Colors.white : AppColors.primaryOrange) : Colors.transparent,
                border: Border.all(
                  color: isDone
                      ? (onOrangeBackground ? Colors.white : AppColors.primaryOrange)
                      : (onOrangeBackground ? Colors.white70 : AppColors.textMuted),
                  width: 1.8,
                ),
              ),
              child: isDone
                  ? Icon(Icons.check, size: 12, color: onOrangeBackground ? AppColors.primaryOrange : Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDone
                          ? (onOrangeBackground ? Colors.white60 : AppColors.textMuted)
                          : Colors.white,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task.subtasksTotal > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${task.subtasksDone}/${task.subtasksTotal} langkah selesai',
                      style: TextStyle(
                        fontSize: 9,
                        color: onOrangeBackground ? Colors.white70 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (task.priority == TaskPriority.urgent && !isDone)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: onOrangeBackground ? Colors.white : AppColors.primaryOrange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Urgent',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: onOrangeBackground ? AppColors.primaryOrange : AppColors.primaryOrangeLight,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── VIEW 2: Kanban Board (Horizontal Scrolling Columns) ───────────────────
  Widget _buildKanbanView() {
    return Column(
      children: [
        _buildKanbanColumn('To Do', TaskStatus.todo, AppColors.info, Icons.radio_button_unchecked_rounded),
        const SizedBox(height: 16),
        _buildKanbanColumn('In Progress', TaskStatus.inProgress, AppColors.warning, Icons.autorenew_rounded),
        const SizedBox(height: 16),
        _buildKanbanColumn('Completed', TaskStatus.completed, AppColors.success, Icons.check_circle_rounded),
      ],
    );
  }

  Widget _buildKanbanColumn(String title, TaskStatus status, Color accentColor, IconData icon) {
    final tasksInColumn = _filteredTasks.where((t) => t.status == status).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${tasksInColumn.length}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: accentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (tasksInColumn.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('Kosong', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ),
            )
          else
            ...tasksInColumn.map((task) => _buildKanbanCard(task)),
        ],
      ),
    );
  }

  Widget _buildKanbanCard(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.workspace,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
              _buildPriorityBadge(task.priority),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            task.title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: task.tags.take(2).map((tag) {
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(fontSize: 8, color: AppColors.textSecondary),
                    ),
                  );
                }).toList(),
              ),
              // Status changer buttons
              Row(
                children: [
                  if (task.status != TaskStatus.completed)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          task.status = TaskStatus.completed;
                          task.subtasksDone = task.subtasksTotal;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, size: 12, color: AppColors.success),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── VIEW 3: All List with Rich Elements & AI Breakdown Button ────────────
  Widget _buildAllListView() {
    final tasks = _filteredTasks;

    if (tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: const Text('Tidak ada tugas ditemukan', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return Column(
      children: tasks.map((task) => _buildRichTaskCard(task)).toList(),
    );
  }

  Widget _buildRichTaskCard(TaskModel task) {
    final isDone = task.status == TaskStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDone
              ? AppColors.cardBorder
              : (task.priority == TaskPriority.urgent
                  ? AppColors.primaryOrange.withOpacity(0.35)
                  : AppColors.cardBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    task.status = isDone ? TaskStatus.inProgress : TaskStatus.completed;
                    if (task.status == TaskStatus.completed) {
                      task.subtasksDone = task.subtasksTotal;
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? AppColors.success : Colors.transparent,
                    border: Border.all(
                      color: isDone ? AppColors.success : AppColors.textMuted,
                      width: 2,
                    ),
                  ),
                  child: isDone ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.description != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        task.description!,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              _buildPriorityBadge(task.priority),
            ],
          ),
          const SizedBox(height: 12),
          // Sub-tasks micro progress bar if any
          if (task.subtasksTotal > 0 && !isDone) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Checklist (${task.subtasksDone}/${task.subtasksTotal})',
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
                Text(
                  '${((task.subtasksDone / task.subtasksTotal) * 100).toInt()}%',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryOrangeLight),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: task.subtasksDone / task.subtasksTotal,
                backgroundColor: AppColors.surfaceSecondary,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 10),
          ],
          // Bottom Row: Workspace pill, tags, and AI Breakdown button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.workspace,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ...task.tags.take(2).map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                      ),
                    );
                  }),
                ],
              ),
              // AI Breakdown button
              if (!isDone)
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✨ Alexa memecah "${task.title}" menjadi 3 sub-langkah otomatis!'),
                        backgroundColor: AppColors.primaryOrange,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrangeSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 10, color: AppColors.primaryOrangeLight),
                        SizedBox(width: 3),
                        Text(
                          'AI Breakdown',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primaryOrangeLight),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(TaskPriority priority) {
    Color col;
    String label;
    switch (priority) {
      case TaskPriority.urgent:
        col = AppColors.primaryOrange;
        label = 'Urgent';
        break;
      case TaskPriority.high:
        col = AppColors.warning;
        label = 'Tinggi';
        break;
      case TaskPriority.medium:
        col = AppColors.info;
        label = 'Sedang';
        break;
      case TaskPriority.low:
        col = AppColors.success;
        label = 'Rendah';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: col.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: col),
      ),
    );
  }

  // ─── Floating Action Button ───────────────────────────────────────────────
  Widget _buildAddFab() {
    return GestureDetector(
      onTap: _showAddTaskModal,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.orangeGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrangeGlow,
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  void _showAddTaskModal() {
    final titleCtrl = TextEditingController();
    String selectedWs = 'Proyek Kuliah';
    TaskPriority selectedPriority = TaskPriority.medium;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tambah Tugas Baru',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: TextField(
                      controller: titleCtrl,
                      autofocus: true,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Apa yang ingin diselesaikan?',
                        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Workspace Selection
                  const Text('Pilih Workspace', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Row(
                    children: ['Proyek Kuliah', 'Tugas Harian', 'Pribadi'].map((ws) {
                      final isSelected = selectedWs == ws;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedWs = ws),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryOrange : AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            ws,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  // Priority Selection
                  const Text('Prioritas', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Row(
                    children: TaskPriority.values.map((p) {
                      final isSelected = selectedPriority == p;
                      final names = {
                        TaskPriority.low: 'Rendah',
                        TaskPriority.medium: 'Sedang',
                        TaskPriority.high: 'Tinggi',
                        TaskPriority.urgent: 'Urgent',
                      };
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedPriority = p),
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryOrange : AppColors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              names[p]!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleCtrl.text.trim().isNotEmpty) {
                          setState(() {
                            _tasks.insert(
                              0,
                              TaskModel(
                                id: DateTime.now().toString(),
                                title: titleCtrl.text.trim(),
                                workspace: selectedWs,
                                priority: selectedPriority,
                                status: TaskStatus.todo,
                                subtasksTotal: 3,
                                subtasksDone: 0,
                                tags: ['New'],
                              ),
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Simpan Tugas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
