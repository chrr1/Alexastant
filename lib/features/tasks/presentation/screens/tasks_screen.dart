import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

enum TaskPriority { low, medium, high, urgent }
enum TaskStatus { todo, inProgress, completed }
enum TasksViewMode { bentoWorkspaces, kanban, allList }

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
  });
}

typedef TaskItemModel = TaskModel;

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  TasksViewMode _viewMode = TasksViewMode.bentoWorkspaces;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // ── Theme animation ────────────────────────────────────────────────────────
  AnimationController? _themeController;
  Animation<double>? _themeAnim;

  void _ensureThemeInitialized() {
    if (_themeController != null) return;
    _themeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _themeAnim = CurvedAnimation(
      parent: _themeController!,
      curve: Curves.easeInOutCubic,
    );
    // Sync to current global state
    if (!ThemeController.instance.isDarkMode) {
      _themeController!.value = 1.0;
    }
  }

  void _onThemeChanged() {
    _ensureThemeInitialized();
    if (ThemeController.instance.isDarkMode) {
      _themeController?.reverse();
    } else {
      _themeController?.forward();
    }
    setState(() {});
  }


  // ── Data ──────────────────────────────────────────────────────────────────
  final List<String> _matkulList = [
    'Algoritma & Pemrograman',
    'Basis Data',
    'Rekayasa Perangkat Lunak',
    'Jaringan Komputer',
    'Kalkulus',
    'Struktur Data',
    'Pemrograman Mobile',
    'Kecerdasan Buatan',
    'Sistem Operasi',
  ];

  final List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      title: 'Siapkan Dokumen SRS & Use Case Diagram',
      description: 'Konfirmasi ruang lingkup modul asisten suara dan siapkan diagram relasi.',
      workspace: 'Kuliah',
      matkul: 'Rekayasa Perangkat Lunak',
      priority: TaskPriority.urgent,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(hours: 1)),
      subtasksTotal: 3,
      subtasksDone: 2,
      tags: ['Tugas', 'Kuliah'],
      isFocus: true,
    ),
    TaskModel(
      id: '2',
      title: 'Buat mockup homepage Alexa Mobile',
      description: 'Desain high-fidelity sesuai referensi Figma dan pastikan responsif.',
      workspace: 'Kuliah',
      matkul: 'Pemrograman Mobile',
      priority: TaskPriority.urgent,
      status: TaskStatus.completed,
      dueDate: DateTime.now(),
      subtasksTotal: 4,
      subtasksDone: 4,
      tags: ['Design', 'Flutter'],
    ),
    TaskModel(
      id: '3',
      title: 'Normalisasi Database 3NF & Schema DDL',
      description: 'Rancang tabel tasks, notes, users dan relasi foreign key untuk Supabase.',
      workspace: 'Kuliah',
      matkul: 'Basis Data',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(hours: 3)),
      subtasksTotal: 3,
      subtasksDone: 2,
      tags: ['DB', 'SQL'],
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
  void initState() {
    super.initState();
    _ensureThemeInitialized();
    ThemeController.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    _themeController?.dispose();
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
          (t.matkul?.toLowerCase().contains(q) ?? false) ||
          t.tags.any((tag) => tag.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _ensureThemeInitialized();

    final completedCount = _tasks.where((t) => t.status == TaskStatus.completed).length;
    final totalCount = _tasks.length;
    final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;
    final focusTask = _tasks.firstWhere(
      (t) => t.isFocus && t.status != TaskStatus.completed,
      orElse: () => _tasks.first,
    );

    return AnimatedBuilder(
      animation: _themeAnim!,
      builder: (context, _) {
        final t = _themeAnim!.value;

        // ── Color tokens ──────────────────────────────────────────────────
        final accentColor = Color.lerp(const Color(0xFFFF5714), const Color(0xFF0A84FF), t)!;
        final bg = Color.lerp(const Color(0xFF0B0B0E), const Color(0xFFF0F4F8), t)!;
        final cardBg = Color.lerp(const Color(0xFF14141A), Colors.white, t)!;
        final cardInnerBg = Color.lerp(const Color(0xFF1F1F24), const Color(0xFFF1F5F9), t)!;
        final cardBorder = Color.lerp(Colors.white.withOpacity(0.08), const Color(0xFFDCE4EE), t)!;
        final textPrimary = Color.lerp(Colors.white, const Color(0xFF0F172A), t)!;
        final textSecondary = Color.lerp(const Color(0xFF8E8E93), const Color(0xFF64748B), t)!;
        final textMuted = Color.lerp(const Color(0xFF55555C), const Color(0xFF94A3B8), t)!;
        final topBtnBg = Color.lerp(AppColors.surface, const Color(0xFFE2EBF5), t)!;
        final topBtnBorder = Color.lerp(Colors.white.withOpacity(0.08), const Color(0xFFCBD8E6), t)!;
        final topIconColor = Color.lerp(AppColors.textPrimary, const Color(0xFF1E293B), t)!;
        final accentGradient = LinearGradient(colors: [
          Color.lerp(const Color(0xFFFF6A28), const Color(0xFF0A84FF), t)!,
          Color.lerp(const Color(0xFFFF4800), const Color(0xFF0066EE), t)!,
        ]);
        final accentGlow = Color.lerp(const Color(0x40FF5714), const Color(0x400A84FF), t)!;
        final accentSoft = Color.lerp(const Color(0x1AFF5714), const Color(0x1A0A84FF), t)!;
        final accentLight = Color.lerp(const Color(0xFFFF8A60), const Color(0xFF5AADFF), t)!;
        final surfaceSecondary = Color.lerp(const Color(0xFF1F1F24), const Color(0xFFF1F5F9), t)!;

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildTopHeader(
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    topBtnBg: topBtnBg,
                    topBtnBorder: topBtnBorder,
                    topIconColor: topIconColor,
                  ),
                  const SizedBox(height: 16),
                  _buildHeroFocusCard(
                    focusTask,
                    t: t,
                    accentColor: accentColor,
                    accentGradient: accentGradient,
                    cardBorder: cardBorder,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    surfaceSecondary: surfaceSecondary,
                    cardInnerBg: cardInnerBg,
                  ),
                  const SizedBox(height: 14),
                  _buildAlexaInsightBanner(
                    cardBg: cardBg,
                    accentColor: accentColor,
                    accentGradient: accentGradient,
                    accentLight: accentLight,
                    textSecondary: textSecondary,
                  ),
                  const SizedBox(height: 16),
                  _buildStatsSummaryRow(
                    completedCount, totalCount, progress,
                    cardBg: cardBg,
                    cardBorder: cardBorder,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: 18),
                  _buildViewModeSwitcher(
                    cardBg: cardBg,
                    cardBorder: cardBorder,
                    cardInnerBg: cardInnerBg,
                    accentColor: accentColor,
                    accentGlow: accentGlow,
                    textSecondary: textSecondary,
                  ),
                  const SizedBox(height: 16),
                  _buildSearchBar(
                    cardBg: cardBg,
                    cardBorder: cardBorder,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    textSecondary: textSecondary,
                  ),
                  const SizedBox(height: 18),
                  if (_viewMode == TasksViewMode.bentoWorkspaces)
                    _buildBentoWorkspacesView(
                      t: t,
                      accentColor: accentColor,
                      accentGradient: accentGradient,
                      accentGlow: accentGlow,
                      accentSoft: accentSoft,
                      accentLight: accentLight,
                      cardBg: cardBg,
                      cardBorder: cardBorder,
                      surfaceSecondary: surfaceSecondary,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      textMuted: textMuted,
                    )
                  else if (_viewMode == TasksViewMode.kanban)
                    _buildKanbanView(
                      cardBg: cardBg,
                      cardBorder: cardBorder,
                      cardInnerBg: cardInnerBg,
                      accentColor: accentColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      textMuted: textMuted,
                      surfaceSecondary: surfaceSecondary,
                    )
                  else
                    _buildAllListView(
                      cardBg: cardBg,
                      cardBorder: cardBorder,
                      accentColor: accentColor,
                      accentSoft: accentSoft,
                      accentLight: accentLight,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      textMuted: textMuted,
                      surfaceSecondary: surfaceSecondary,
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          floatingActionButton: _buildAddFab(
            accentGradient: accentGradient,
            accentGlow: accentGlow,
          ),
        );
      },
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildTopHeader({
    required Color textPrimary,
    required Color textSecondary,
    required Color topBtnBg,
    required Color topBtnBorder,
    required Color topIconColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tugas & Proyek',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Senin, 02 November 2026',
              style: TextStyle(fontSize: 12, color: textSecondary),
            ),
          ],
        ),
        // Filter button
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: topBtnBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: topBtnBorder),
          ),
          child: Icon(
            Icons.tune_rounded,
            color: topIconColor,
            size: 20,
          ),
        ),
      ],
    );
  }

  // ─── 1. Hero Focus Card ────────────────────────────────────────────────────
  Widget _buildHeroFocusCard(
    TaskModel task, {
    required double t,
    required Color accentColor,
    required LinearGradient accentGradient,
    required Color cardBorder,
    required Color textPrimary,
    required Color textMuted,
    required Color surfaceSecondary,
    required Color cardInnerBg,
  }) {
    final isDone = task.status == TaskStatus.completed;

    // Hero card stays dark/glassmorphic: lerp between dark card and light neutral
    final heroBg1 = Color.lerp(const Color(0xFF1F1F26), const Color(0xFFFFFFFF), t)!;
    final heroBg2 = Color.lerp(const Color(0xFF16161C), const Color(0xFFF8FAFC), t)!;
    final heroBorder = Color.lerp(Colors.white.withOpacity(0.4), const Color(0xFFDCE4EE), t)!;
    final heroChipBg = Color.lerp(Colors.white.withOpacity(0.15), const Color(0xFF0A84FF).withOpacity(0.1), t)!;
    final heroChipText = Color.lerp(Colors.white, const Color(0xFF0F172A), t)!;
    final heroDescColor = Color.lerp(Colors.white, const Color(0xFF475569), t)!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [heroBg1, heroBg2],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: heroBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 8),
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
                  color: heroChipBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: heroChipText),
                    const SizedBox(width: 4),
                    Text(
                      'FOKUS UTAMA HARI INI',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: heroChipText,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: heroChipBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Sisa 1 jam lagi',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: heroChipText,
                  ),
                ),
              ),
            ],
          ),
          if (task.matkul != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: heroChipBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_rounded, color: heroChipText, size: 11),
                  const SizedBox(width: 4),
                  Text(
                    task.matkul!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: heroChipText,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDone ? textMuted : textPrimary,
              decoration: isDone ? TextDecoration.lineThrough : null,
              height: 1.3,
            ),
          ),
          if (task.description != null) ...[
            const SizedBox(height: 6),
            Text(
              task.description!,
              style: TextStyle(fontSize: 11, color: heroDescColor, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 14),
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
                          style: TextStyle(fontSize: 10, color: textMuted),
                        ),
                        Text(
                          '${((task.subtasksDone / task.subtasksTotal) * 100).toInt()}%',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: task.subtasksTotal > 0 ? (task.subtasksDone / task.subtasksTotal) : 0,
                        backgroundColor: Colors.black.withOpacity(0.08),
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showRescheduleSheet(
                    task,
                    accentColor: accentColor,
                    cardBg: Color.lerp(AppColors.surface, Colors.white, t)!,
                    cardBorder: cardBorder,
                    textPrimary: textPrimary,
                    textSecondary: Color.lerp(const Color(0xFF8E8E93), const Color(0xFF64748B), t)!,
                    textMuted: Color.lerp(const Color(0xFF55555C), const Color(0xFF94A3B8), t)!,
                    surfaceSecondary: surfaceSecondary,
                    cardInnerBg: cardInnerBg,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.lerp(AppColors.surfaceSecondary, const Color(0xFFF1F5F9), t),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_repeat_rounded, size: 16, color: textPrimary),
                        const SizedBox(width: 6),
                        Text(
                          'Jadwalkan Ulang',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary),
                        ),
                      ],
                    ),
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
                    gradient: isDone ? null : accentGradient,
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
  Widget _buildAlexaInsightBanner({
    required Color cardBg,
    required Color accentColor,
    required LinearGradient accentGradient,
    required Color accentLight,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: accentGradient,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11, color: textSecondary, height: 1.4),
                children: [
                  TextSpan(
                    text: 'Saran Alexa: ',
                    style: TextStyle(fontWeight: FontWeight.w700, color: accentLight),
                  ),
                  const TextSpan(
                    text: 'Selesaikan tugas klien PT Maju sebelum jam 14:00 karena ada agenda evaluasi meeting offline setelahnya.',
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
  Widget _buildStatsSummaryRow(
    int completed,
    int total,
    double progress, {
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textSecondary,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: Colors.black.withOpacity(0.06),
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
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
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '2 tugas berprioritas mendesak',
                    style: TextStyle(fontSize: 11, color: textSecondary),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Hari Ini',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 4. View Mode Switcher ────────────────────────────────────────────────
  Widget _buildViewModeSwitcher({
    required Color cardBg,
    required Color cardBorder,
    required Color cardInnerBg,
    required Color accentColor,
    required Color accentGlow,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cardInnerBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          _buildViewModeButton('Bento Proyek', TasksViewMode.bentoWorkspaces, Icons.grid_view_rounded,
              accentColor: accentColor, accentGlow: accentGlow, textSecondary: textSecondary),
          _buildViewModeButton('Kanban Board', TasksViewMode.kanban, Icons.view_column_rounded,
              accentColor: accentColor, accentGlow: accentGlow, textSecondary: textSecondary),
          _buildViewModeButton('Daftar Semua', TasksViewMode.allList, Icons.format_list_bulleted_rounded,
              accentColor: accentColor, accentGlow: accentGlow, textSecondary: textSecondary),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(
    String title,
    TasksViewMode mode,
    IconData icon, {
    required Color accentColor,
    required Color accentGlow,
    required Color textSecondary,
  }) {
    final isSelected = _viewMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _viewMode = mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? accentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [BoxShadow(color: accentGlow, blurRadius: 10, offset: const Offset(0, 3))]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: isSelected ? Colors.white : textSecondary),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Search Bar ───────────────────────────────────────────────────────────
  Widget _buildSearchBar({
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textMuted,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: textMuted, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: TextStyle(color: textPrimary, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Cari tugas, tag, atau workspace...',
                hintStyle: TextStyle(color: textMuted, fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: Icon(Icons.close_rounded, color: textSecondary, size: 18),
            ),
        ],
      ),
    );
  }

  // ─── VIEW 1: Bento Workspace Cards ─────────────────────────────────────────
  Widget _buildBentoWorkspacesView({
    required double t,
    required Color accentColor,
    required LinearGradient accentGradient,
    required Color accentGlow,
    required Color accentSoft,
    required Color accentLight,
    required Color cardBg,
    required Color cardBorder,
    required Color surfaceSecondary,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
  }) {
    final workspaces = ['Kuliah', 'Tugas Harian', 'Pribadi'];

    return Column(
      children: workspaces.map((ws) {
        final tasks = _filteredTasks.where((t2) => t2.workspace == ws).toList();
        if (tasks.isEmpty) return const SizedBox.shrink();

        final done = tasks.where((t2) => t2.status == TaskStatus.completed).length;
        final total = tasks.length;
        final wsProgress = total > 0 ? (done / total) : 0.0;
        final isAccentCard = ws == 'Tugas Harian';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: isAccentCard ? accentGradient : null,
            color: isAccentCard ? null : cardBg,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: isAccentCard ? Colors.transparent : cardBorder),
            boxShadow: isAccentCard
                ? [BoxShadow(color: accentGlow, blurRadius: 18, offset: const Offset(0, 6))]
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
                          color: isAccentCard ? Colors.white.withOpacity(0.2) : surfaceSecondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isAccentCard ? Icons.workspaces_rounded : Icons.folder_open_rounded,
                          size: 16,
                          color: isAccentCard ? Colors.white : textPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ws,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isAccentCard ? Colors.white : textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isAccentCard ? Colors.white.withOpacity(0.2) : surfaceSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$done/$total selesai',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isAccentCard ? Colors.white : textSecondary,
                      ),
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
                  backgroundColor: isAccentCard ? Colors.white.withOpacity(0.15) : surfaceSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isAccentCard ? Colors.white : accentColor,
                  ),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 14),
              // Task Items
              ...tasks.map((task) => _buildBentoTaskItem(
                    task,
                    isAccentCard,
                    accentColor: accentColor,
                    accentSoft: accentSoft,
                    accentLight: accentLight,
                    surfaceSecondary: surfaceSecondary,
                    cardBorder: cardBorder,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    textSecondary: textSecondary,
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBentoTaskItem(
    TaskModel task,
    bool onAccentBackground, {
    required Color accentColor,
    required Color accentSoft,
    required Color accentLight,
    required Color surfaceSecondary,
    required Color cardBorder,
    required Color textPrimary,
    required Color textMuted,
    required Color textSecondary,
  }) {
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
          color: onAccentBackground ? Colors.black.withOpacity(0.15) : surfaceSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: onAccentBackground ? Colors.white.withOpacity(0.1) : cardBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? (onAccentBackground ? Colors.white : accentColor)
                    : Colors.transparent,
                border: Border.all(
                  color: isDone
                      ? (onAccentBackground ? Colors.white : accentColor)
                      : (onAccentBackground ? Colors.white70 : textMuted),
                  width: 1.8,
                ),
              ),
              child: isDone
                  ? Icon(Icons.check, size: 12,
                      color: onAccentBackground ? accentColor : Colors.white)
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
                          ? (onAccentBackground ? Colors.white60 : textMuted)
                          : (onAccentBackground ? Colors.white : textPrimary),
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      if (task.matkul != null) ...[
                        Text(
                          '📚 ${task.matkul}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: onAccentBackground ? Colors.white : accentColor,
                          ),
                        ),
                        if (task.subtasksTotal > 0)
                          Text(
                            ' • ',
                            style: TextStyle(
                              fontSize: 9,
                              color: onAccentBackground ? Colors.white60 : textMuted,
                            ),
                          ),
                      ],
                      if (task.subtasksTotal > 0)
                        Text(
                          '${task.subtasksDone}/${task.subtasksTotal} langkah selesai',
                          style: TextStyle(
                            fontSize: 9,
                            color: onAccentBackground ? Colors.white70 : textSecondary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (task.priority == TaskPriority.urgent && !isDone)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: onAccentBackground ? Colors.white : accentSoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Urgent',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: onAccentBackground ? accentColor : accentColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── VIEW 2: Kanban Board ──────────────────────────────────────────────────
  Widget _buildKanbanView({
    required Color cardBg,
    required Color cardBorder,
    required Color cardInnerBg,
    required Color accentColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color surfaceSecondary,
  }) {
    return Column(
      children: [
        _buildKanbanColumn('To Do', TaskStatus.todo, AppColors.info, Icons.radio_button_unchecked_rounded,
            cardBg: cardBg, cardBorder: cardBorder, cardInnerBg: cardInnerBg,
            textPrimary: textPrimary, textSecondary: textSecondary, textMuted: textMuted,
            surfaceSecondary: surfaceSecondary, accentColor: accentColor),
        const SizedBox(height: 16),
        // Use interpolated accentColor for 'In Progress' to replace orange in light mode
        _buildKanbanColumn('In Progress', TaskStatus.inProgress, accentColor, Icons.autorenew_rounded,
            cardBg: cardBg, cardBorder: cardBorder, cardInnerBg: cardInnerBg,
            textPrimary: textPrimary, textSecondary: textSecondary, textMuted: textMuted,
            surfaceSecondary: surfaceSecondary, accentColor: accentColor),
        const SizedBox(height: 16),
        _buildKanbanColumn('Completed', TaskStatus.completed, AppColors.success, Icons.check_circle_rounded,
            cardBg: cardBg, cardBorder: cardBorder, cardInnerBg: cardInnerBg,
            textPrimary: textPrimary, textSecondary: textSecondary, textMuted: textMuted,
            surfaceSecondary: surfaceSecondary, accentColor: accentColor),
      ],
    );
  }

  Widget _buildKanbanColumn(
    String title,
    TaskStatus status,
    Color colAccent,
    IconData icon, {
    required Color cardBg,
    required Color cardBorder,
    required Color cardInnerBg,
    required Color accentColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color surfaceSecondary,
  }) {
    final tasksInColumn = _filteredTasks.where((t) => t.status == status).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: colAccent),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${tasksInColumn.length}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (tasksInColumn.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('Kosong', style: TextStyle(fontSize: 11, color: textMuted)),
              ),
            )
          else
            ...tasksInColumn.map((task) => _buildKanbanCard(
                  task,
                  accentColor: accentColor,
                  cardBorder: cardBorder,
                  surfaceSecondary: surfaceSecondary,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  textMuted: textMuted,
                )),
        ],
      ),
    );
  }

  Widget _buildKanbanCard(
    TaskModel task, {
    required Color accentColor,
    required Color cardBorder,
    required Color surfaceSecondary,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    task.workspace,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: textSecondary),
                  ),
                  if (task.matkul != null) ...[
                    Text(' • ', style: TextStyle(fontSize: 9, color: textMuted)),
                    Text(
                      task.matkul!,
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: accentColor),
                    ),
                  ],
                ],
              ),
              _buildPriorityBadge(task.priority, accentColor: accentColor),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            task.title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary),
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
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(fontSize: 8, color: textSecondary),
                    ),
                  );
                }).toList(),
              ),
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

  // ─── VIEW 3: All List ─────────────────────────────────────────────────────
  Widget _buildAllListView({
    required Color cardBg,
    required Color cardBorder,
    required Color accentColor,
    required Color accentSoft,
    required Color accentLight,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color surfaceSecondary,
  }) {
    final tasks = _filteredTasks;

    if (tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Text('Tidak ada tugas ditemukan', style: TextStyle(color: textSecondary)),
      );
    }

    return Column(
      children: tasks
          .map((task) => _buildRichTaskCard(
                task,
                cardBg: cardBg,
                cardBorder: cardBorder,
                accentColor: accentColor,
                accentSoft: accentSoft,
                accentLight: accentLight,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                textMuted: textMuted,
                surfaceSecondary: surfaceSecondary,
              ))
          .toList(),
    );
  }

  Widget _buildRichTaskCard(
    TaskModel task, {
    required Color cardBg,
    required Color cardBorder,
    required Color accentColor,
    required Color accentSoft,
    required Color accentLight,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color surfaceSecondary,
  }) {
    final isDone = task.status == TaskStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDone
              ? cardBorder
              : (task.priority == TaskPriority.urgent
                  ? accentColor.withOpacity(0.35)
                  : cardBorder),
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
                      color: isDone ? AppColors.success : textMuted,
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
                        color: isDone ? textMuted : textPrimary,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.description != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        task.description!,
                        style: TextStyle(fontSize: 11, color: textSecondary, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              _buildPriorityBadge(task.priority, accentColor: accentColor),
            ],
          ),
          const SizedBox(height: 12),
          if (task.subtasksTotal > 0 && !isDone) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Checklist (${task.subtasksDone}/${task.subtasksTotal})',
                  style: TextStyle(fontSize: 10, color: textSecondary),
                ),
                Text(
                  '${((task.subtasksDone / task.subtasksTotal) * 100).toInt()}%',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: accentLight),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: task.subtasksDone / task.subtasksTotal,
                backgroundColor: surfaceSecondary,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: surfaceSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.workspace,
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: textSecondary),
                    ),
                  ),
                  if (task.matkul != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: accentSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '📚 ${task.matkul}',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 6),
                  ...task.tags.take(2).map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        '#$tag',
                        style: TextStyle(fontSize: 9, color: textMuted),
                      ),
                    );
                  }),
                ],
              ),
              if (!isDone)
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✨ Alexa memecah "${task.title}" menjadi 3 sub-langkah otomatis!'),
                        backgroundColor: accentColor,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accentSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 10, color: accentLight),
                        const SizedBox(width: 3),
                        Text(
                          'AI Breakdown',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: accentLight),
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

  Widget _buildPriorityBadge(TaskPriority priority, {required Color accentColor}) {
    Color col;
    String label;
    switch (priority) {
      case TaskPriority.urgent:
        col = accentColor;
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
  Widget _buildAddFab({
    required LinearGradient accentGradient,
    required Color accentGlow,
  }) {
    return GestureDetector(
      onTap: () {
        _ensureThemeInitialized();
        final t = _themeAnim!.value;
        final accentColor = Color.lerp(const Color(0xFFFF5714), const Color(0xFF0A84FF), t)!;
        final cardBg = Color.lerp(const Color(0xFF14141A), Colors.white, t)!;
        final cardBorder = Color.lerp(Colors.white.withOpacity(0.08), const Color(0xFFDCE4EE), t)!;
        final textPrimary = Color.lerp(Colors.white, const Color(0xFF0F172A), t)!;
        final textSecondary = Color.lerp(const Color(0xFF8E8E93), const Color(0xFF64748B), t)!;
        final textMuted = Color.lerp(const Color(0xFF55555C), const Color(0xFF94A3B8), t)!;
        final surfaceSecondary = Color.lerp(const Color(0xFF1F1F24), const Color(0xFFF1F5F9), t)!;
        final cardInnerBg = surfaceSecondary;
        _showAddTaskModal(
          accentColor: accentColor,
          accentGradient: accentGradient,
          cardBg: cardBg,
          cardBorder: cardBorder,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          textMuted: textMuted,
          surfaceSecondary: surfaceSecondary,
          cardInnerBg: cardInnerBg,
        );
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: accentGradient,
          boxShadow: [
            BoxShadow(
              color: accentGlow,
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  // ─── Reschedule Bottom Sheet ───────────────────────────────────────────────
  void _showRescheduleSheet(
    TaskModel task, {
    required Color accentColor,
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color surfaceSecondary,
    required Color cardInnerBg,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: cardBorder, width: 1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: textMuted.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.event_repeat_rounded, color: accentColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jadwalkan Ulang',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                        Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildRescheduleOption(
                icon: Icons.timer_outlined,
                title: 'Nanti Sore (+3 Jam)',
                subtitle: 'Beri jeda istirahat sebelum lanjut',
                accentColor: accentColor,
                surfaceSecondary: surfaceSecondary,
                cardBorder: cardBorder,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                textMuted: textMuted,
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => task.dueDate = DateTime.now().add(const Duration(hours: 3)));
                  _showRescheduleToast('Jadwal diundur 3 jam', accentColor: accentColor);
                },
              ),
              _buildRescheduleOption(
                icon: Icons.wb_sunny_outlined,
                title: 'Besok Pagi',
                subtitle: 'Pukul 09:00 WIB',
                accentColor: accentColor,
                surfaceSecondary: surfaceSecondary,
                cardBorder: cardBorder,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                textMuted: textMuted,
                onTap: () {
                  Navigator.pop(ctx);
                  final tomorrow = DateTime.now().add(const Duration(days: 1));
                  setState(() => task.dueDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0));
                  _showRescheduleToast('Jadwal dipindah ke Besok 09:00', accentColor: accentColor);
                },
              ),
              _buildRescheduleOption(
                icon: Icons.nights_stay_outlined,
                title: 'Besok Malam',
                subtitle: 'Pukul 20:00 WIB',
                accentColor: accentColor,
                surfaceSecondary: surfaceSecondary,
                cardBorder: cardBorder,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                textMuted: textMuted,
                onTap: () {
                  Navigator.pop(ctx);
                  final tomorrow = DateTime.now().add(const Duration(days: 1));
                  setState(() => task.dueDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 20, 0));
                  _showRescheduleToast('Jadwal dipindah ke Besok 20:00', accentColor: accentColor);
                },
              ),
              _buildRescheduleOption(
                icon: Icons.calendar_month_outlined,
                title: 'Pilih Tanggal Kustom',
                subtitle: 'Tentukan tanggal spesifik lewat kalender',
                accentColor: accentColor,
                surfaceSecondary: surfaceSecondary,
                cardBorder: cardBorder,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                textMuted: textMuted,
                onTap: () async {
                  Navigator.pop(ctx);
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: task.dueDate ?? DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: accentColor,
                            surface: cardBg,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() => task.dueDate = picked);
                    _showRescheduleToast('Jadwal berhasil diperbarui', accentColor: accentColor);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRescheduleOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color accentColor,
    required Color surfaceSecondary,
    required Color cardBorder,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: surfaceSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: accentColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: textMuted),
          ],
        ),
      ),
    );
  }

  void _showRescheduleToast(String message, {required Color accentColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: accentColor, size: 18),
            const SizedBox(width: 10),
            Text(message, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          ],
        ),
        backgroundColor: const Color(0xFF1E1E26),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─── Add Task Modal ────────────────────────────────────────────────────────
  void _showAddTaskModal({
    required Color accentColor,
    required LinearGradient accentGradient,
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color surfaceSecondary,
    required Color cardInnerBg,
  }) {
    final titleCtrl = TextEditingController();
    final subtaskCtrl = TextEditingController();
    final customMatkulCtrl = TextEditingController();
    String selectedWs = 'Kuliah';
    String? selectedMatkul = _matkulList.first;
    bool isAddingCustomMatkul = false;
    TaskPriority selectedPriority = TaskPriority.medium;
    DateTime selectedDueDate = DateTime.now().add(const Duration(days: 1));
    final List<String> subtasks = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.88,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: cardBorder,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tambah Tugas Baru',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                'To-Do item dengan checklist & deadline',
                                style: TextStyle(fontSize: 11, color: textSecondary),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: surfaceSecondary,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: cardBorder),
                              ),
                              child: Icon(Icons.close_rounded, color: textSecondary, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Title Field
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: surfaceSecondary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: cardBorder),
                        ),
                        child: TextField(
                          controller: titleCtrl,
                          autofocus: true,
                          style: TextStyle(color: textPrimary, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Apa yang ingin diselesaikan?',
                            hintStyle: TextStyle(color: textMuted, fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Workspace Selection
                      Text(
                        'Kategori / Workspace',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ['Kuliah', 'Tugas Harian', 'Pribadi'].map((ws) {
                          final isSelected = selectedWs == ws;
                          return GestureDetector(
                            onTap: () => setModalState(() {
                              selectedWs = ws;
                              if (ws == 'Kuliah' && selectedMatkul == null) {
                                selectedMatkul = _matkulList.first;
                              }
                            }),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: isSelected ? accentColor : surfaceSecondary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? accentColor : cardBorder,
                                ),
                              ),
                              child: Text(
                                ws,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? Colors.white : textSecondary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Mata Kuliah Selector
                      if (selectedWs == 'Kuliah') ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.menu_book_rounded, color: accentColor, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  'Pilih Mata Kuliah',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: accentColor,
                                  ),
                                ),
                              ],
                            ),
                            if (!isAddingCustomMatkul)
                              GestureDetector(
                                onTap: () => setModalState(() => isAddingCustomMatkul = true),
                                child: Text(
                                  '+ Tambah Baru',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: accentColor.withOpacity(0.7),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (isAddingCustomMatkul)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: surfaceSecondary,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: accentColor),
                                  ),
                                  child: TextField(
                                    controller: customMatkulCtrl,
                                    autofocus: true,
                                    style: TextStyle(color: textPrimary, fontSize: 12),
                                    decoration: InputDecoration(
                                      hintText: 'Nama mata kuliah baru...',
                                      hintStyle: TextStyle(color: textMuted, fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  final name = customMatkulCtrl.text.trim();
                                  if (name.isNotEmpty) {
                                    setModalState(() {
                                      _matkulList.insert(0, name);
                                      selectedMatkul = name;
                                      customMatkulCtrl.clear();
                                      isAddingCustomMatkul = false;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    gradient: accentGradient,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                                ),
                              ),
                            ],
                          )
                        else
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: _matkulList.map((mk) {
                                final isSelected = selectedMatkul == mk;
                                return GestureDetector(
                                  onTap: () => setModalState(() => selectedMatkul = mk),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isSelected ? accentColor.withOpacity(0.18) : surfaceSecondary,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected ? accentColor : cardBorder,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isSelected) ...[
                                          Icon(Icons.check_rounded, size: 12, color: accentColor),
                                          const SizedBox(width: 4),
                                        ],
                                        Text(
                                          mk,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                            color: isSelected ? accentColor : textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                      const SizedBox(height: 16),

                      // Priority Selection
                      Text(
                        'Tingkat Prioritas',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary),
                      ),
                      const SizedBox(height: 8),
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
                                  color: isSelected ? accentColor : surfaceSecondary,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? accentColor : cardBorder,
                                  ),
                                ),
                                child: Text(
                                  names[p]!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? Colors.white : textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Due Date Picker
                      Text(
                        'Tenggat Waktu (Due Date)',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDueDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: accentColor,
                                    surface: cardBg,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setModalState(() => selectedDueDate = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: surfaceSecondary,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: cardBorder),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_rounded, color: accentColor, size: 16),
                              const SizedBox(width: 10),
                              Text(
                                '${selectedDueDate.day}/${selectedDueDate.month}/${selectedDueDate.year}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.arrow_drop_down_rounded, color: textSecondary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Subtasks
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtask / Langkah Checklist',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary),
                          ),
                          Text(
                            '${subtasks.length} item',
                            style: TextStyle(fontSize: 10, color: textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: surfaceSecondary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: cardBorder),
                              ),
                              child: TextField(
                                controller: subtaskCtrl,
                                style: TextStyle(color: textPrimary, fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'Tambah langkah subtask...',
                                  hintStyle: TextStyle(color: textMuted, fontSize: 12),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              final text = subtaskCtrl.text.trim();
                              if (text.isNotEmpty) {
                                setModalState(() {
                                  subtasks.add(text);
                                  subtaskCtrl.clear();
                                });
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      if (subtasks.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ...subtasks.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final item = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: surfaceSecondary,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: cardBorder),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_box_outline_blank_rounded,
                                    size: 16, color: textSecondary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: TextStyle(fontSize: 12, color: textPrimary),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setModalState(() => subtasks.removeAt(idx)),
                                  child: Icon(Icons.close_rounded, size: 16, color: textMuted),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
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
                                    matkul: selectedWs == 'Kuliah' ? selectedMatkul : null,
                                    priority: selectedPriority,
                                    status: TaskStatus.todo,
                                    dueDate: selectedDueDate,
                                    subtasksTotal: subtasks.isEmpty ? 1 : subtasks.length,
                                    subtasksDone: 0,
                                    tags: [
                                      'To-Do',
                                      if (selectedWs == 'Kuliah' && selectedMatkul != null)
                                        selectedMatkul!,
                                    ],
                                  ),
                                );
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tugas baru berhasil ditambahkan! ✓'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Simpan Tugas',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
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
      },
    );
  }
}
