import 'package:flutter/material.dart';
import '../../../domain/models/task_model.dart';

/// Comprehensive CRUD Form Modal for Tasks:
/// - Create (Tambah) new task with subtasks, matkul, priority, due time, duration.
/// - Edit (Ubah) existing task with prefilled fields.
/// - Delete (Hapus) existing task with safety confirmation dialog.
class TaskCrudModal extends StatefulWidget {
  final bool isDark;
  final TaskModel? taskToEdit;
  final ValueChanged<TaskModel> onSave;
  final ValueChanged<String>? onDelete;

  const TaskCrudModal({
    super.key,
    required this.isDark,
    this.taskToEdit,
    required this.onSave,
    this.onDelete,
  });

  static Future<void> show({
    required BuildContext context,
    required bool isDark,
    TaskModel? taskToEdit,
    required ValueChanged<TaskModel> onSave,
    ValueChanged<String>? onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TaskCrudModal(
        isDark: isDark,
        taskToEdit: taskToEdit,
        onSave: onSave,
        onDelete: onDelete,
      ),
    );
  }

  @override
  State<TaskCrudModal> createState() => _TaskCrudModalState();
}

class _TaskCrudModalState extends State<TaskCrudModal> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _matkulCtrl;
  late final TextEditingController _newSubtaskCtrl;

  late TaskPriority _selectedPriority;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late List<SubtaskItem> _subtasks;

  bool get _isEditMode => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    final task = widget.taskToEdit;
    _titleCtrl = TextEditingController(text: task?.title ?? '');
    _descCtrl = TextEditingController(text: task?.description ?? '');
    _matkulCtrl = TextEditingController(text: task?.matkul ?? task?.workspace ?? 'Kuliah');
    _newSubtaskCtrl = TextEditingController();

    _selectedPriority = task?.priority ?? TaskPriority.medium;

    if (task?.dueDate != null) {
      _selectedDate = DateTime(task!.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
      _selectedTime = TimeOfDay(hour: task.dueDate!.hour, minute: task.dueDate!.minute);
    } else {
      _selectedDate = DateTime.now();
      _selectedTime = const TimeOfDay(hour: 17, minute: 0);
    }

    // Clone subtasks to prevent direct state mutation before saving
    _subtasks = task?.subtasks.map((s) => SubtaskItem(
          id: s.id,
          title: s.title,
          isCompleted: s.isCompleted,
        )).toList() ?? [];
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _matkulCtrl.dispose();
    _newSubtaskCtrl.dispose();
    super.dispose();
  }

  void _addSubtask() {
    final text = _newSubtaskCtrl.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _subtasks.add(
          SubtaskItem(
            id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
            title: text,
            isCompleted: false,
          ),
        );
        _newSubtaskCtrl.clear();
      });
    }
  }

  void _removeSubtask(int index) {
    setState(() {
      _subtasks.removeAt(index);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (context, child) {
        return Theme(
          data: widget.isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xFF6366F1),
                    onPrimary: Colors.white,
                    surface: Color(0xFF1E293B),
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF50689C),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Color(0xFF0F172A),
                  ),
                ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDateString(DateTime date) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final tomorrow = now.add(const Duration(days: 1));
    final isTomorrow = date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;

    if (isToday) return 'Hari ini, ${date.day} ${monthNames[date.month - 1]}';
    if (isTomorrow) return 'Besok, ${date.day} ${monthNames[date.month - 1]}';
    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitSave() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul tugas tidak boleh kosong'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final dueDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final savedTask = TaskModel(
      id: widget.taskToEdit?.id ?? 'task_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: _descCtrl.text.trim().isNotEmpty ? _descCtrl.text.trim() : null,
      workspace: _matkulCtrl.text.trim().isNotEmpty ? _matkulCtrl.text.trim() : 'Kuliah',
      matkul: _matkulCtrl.text.trim().isNotEmpty ? _matkulCtrl.text.trim() : 'Kuliah',
      priority: _selectedPriority,
      status: widget.taskToEdit?.status ?? TaskStatus.todo,
      dueDate: dueDate,
      subtasks: _subtasks,
      isFocus: widget.taskToEdit?.isFocus ?? false,
    );

    widget.onSave(savedTask);
    Navigator.pop(context);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Hapus Tugas?',
          style: TextStyle(
            color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Tugas "${_titleCtrl.text}" akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(
            color: widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: TextStyle(
                color: widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close modal
              if (widget.onDelete != null && widget.taskToEdit != null) {
                widget.onDelete!(widget.taskToEdit!.id);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final fieldFillColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 42,
                height: 4.5,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header Row: Title + Delete button (if edit mode)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditMode ? 'Edit Tugas' : 'Tambah Tugas Baru',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                if (_isEditMode)
                  IconButton(
                    onPressed: _confirmDelete,
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                    tooltip: 'Hapus Tugas',
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // ─── 1. Judul Tugas ─────────────────────────────────────────────
            _buildLabel('JUDUL TUGAS *', textMuted),
            const SizedBox(height: 6),
            TextField(
              controller: _titleCtrl,
              style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
              decoration: _inputDecoration(
                hint: 'Contoh: Laporan Praktikum Mobile',
                fillColor: fieldFillColor,
                borderColor: borderColor,
                textMuted: textMuted,
              ),
            ),

            const SizedBox(height: 16),

            // ─── 2. Deskripsi ───────────────────────────────────────────────
            _buildLabel('DESKRIPSI (OPSIONAL)', textMuted),
            const SizedBox(height: 6),
            TextField(
              controller: _descCtrl,
              maxLines: 2,
              style: TextStyle(color: textPrimary, fontSize: 13.5),
              decoration: _inputDecoration(
                hint: 'Detail catatan atau instruksi pengerjaan...',
                fillColor: fieldFillColor,
                borderColor: borderColor,
                textMuted: textMuted,
              ),
            ),

            const SizedBox(height: 16),

            // ─── 3. Mata Kuliah / Workspace ─────────────────────────────────
            _buildLabel('MATA KULIAH / KATEGORI', textMuted),
            const SizedBox(height: 6),
            TextField(
              controller: _matkulCtrl,
              style: TextStyle(color: textPrimary, fontSize: 13.5),
              decoration: _inputDecoration(
                hint: 'Contoh: Desain Komunikasi Visual',
                fillColor: fieldFillColor,
                borderColor: borderColor,
                textMuted: textMuted,
              ),
            ),

            const SizedBox(height: 18),

            // ─── 4. Prioritas ───────────────────────────────────────────────
            _buildLabel('PRIORITAS', textMuted),
            const SizedBox(height: 8),
            Row(
              children: TaskPriority.values.map((p) {
                final isSelected = _selectedPriority == p;
                Color pColor;
                String pText;
                switch (p) {
                  case TaskPriority.urgent:
                    pColor = const Color(0xFFEF4444);
                    pText = 'Urgent';
                    break;
                  case TaskPriority.high:
                    pColor = const Color(0xFFF97316);
                    pText = 'High';
                    break;
                  case TaskPriority.medium:
                    pColor = const Color(0xFF3B82F6);
                    pText = 'Medium';
                    break;
                  case TaskPriority.low:
                    pColor = const Color(0xFF10B981);
                    pText = 'Low';
                    break;
                }

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPriority = p),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? pColor.withOpacity(0.15) : fieldFillColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? pColor : borderColor,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Text(
                        pText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? pColor : textMuted,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 18),

            // ─── 5. Tenggat Waktu (Tanggal & Jam) ───────────────────────────
            _buildLabel('TENGGAT WAKTU (DEADLINE)', textMuted),
            const SizedBox(height: 6),
            Row(
              children: [
                // Tanggal Picker
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                      decoration: BoxDecoration(
                        color: fieldFillColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 15, color: textMuted),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _formatDateString(_selectedDate),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Jam Picker
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _pickTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: fieldFillColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 15, color: textMuted),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')} WIB',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ─── 6. Subtasks Checklist Builder ──────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel('SUBTASKS (${_subtasks.length})', textMuted),
                Text(
                  'Langkah Pengerjaan',
                  style: TextStyle(fontSize: 11, color: textMuted),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Subtasks list
            if (_subtasks.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _subtasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (ctx, i) {
                  final sub = _subtasks[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: fieldFillColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          sub.isCompleted
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 16,
                          color: sub.isCompleted ? const Color(0xFF10B981) : textMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            sub.title,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: textPrimary,
                              decoration: sub.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close_rounded, size: 16, color: Color(0xFFEF4444)),
                          onPressed: () => _removeSubtask(i),
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 8),

            // Input to add new subtask
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newSubtaskCtrl,
                    style: TextStyle(color: textPrimary, fontSize: 13),
                    decoration: _inputDecoration(
                      hint: 'Tambah langkah baru...',
                      fillColor: fieldFillColor,
                      borderColor: borderColor,
                      textMuted: textMuted,
                    ),
                    onSubmitted: (_) => _addSubtask(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addSubtask,
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF3B82F6) : const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ─── 7. Tombol Simpan ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF3B82F6) : const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _isEditMode ? 'Simpan Perubahan' : 'Tambah Tugas',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.5,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required Color fillColor,
    required Color borderColor,
    required Color textMuted,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: textMuted, fontSize: 13),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
      ),
    );
  }
}

