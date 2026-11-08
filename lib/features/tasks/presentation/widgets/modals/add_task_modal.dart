import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';
import 'package:alexa/features/tasks/domain/models/task_model.dart';

class AddTaskModal extends StatefulWidget {
  final List<String> matkulList;
  final Color accentColor;
  final LinearGradient accentGradient;
  final Color cardBg;
  final Color cardBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color surfaceSecondary;
  final Color cardInnerBg;
  final ValueChanged<TaskModel> onTaskCreated;

  const AddTaskModal({
    super.key,
    required this.matkulList,
    required this.accentColor,
    required this.accentGradient,
    required this.cardBg,
    required this.cardBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.surfaceSecondary,
    required this.cardInnerBg,
    required this.onTaskCreated,
  });

  static void show(
    BuildContext context, {
    required List<String> matkulList,
    required Color accentColor,
    required LinearGradient accentGradient,
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color surfaceSecondary,
    required Color cardInnerBg,
    required ValueChanged<TaskModel> onTaskCreated,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => AddTaskModal(
        matkulList: matkulList,
        accentColor: accentColor,
        accentGradient: accentGradient,
        cardBg: cardBg,
        cardBorder: cardBorder,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        textMuted: textMuted,
        surfaceSecondary: surfaceSecondary,
        cardInnerBg: cardInnerBg,
        onTaskCreated: onTaskCreated,
      ),
    );
  }

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _titleCtrl = TextEditingController();
  final _subtaskCtrl = TextEditingController();
  final _customMatkulCtrl = TextEditingController();

  late String _selectedWs;
  String? _selectedMatkul;
  bool _isAddingCustomMatkul = false;
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 1));
  final List<String> _subtasks = [];

  @override
  void initState() {
    super.initState();
    _selectedWs = 'Kuliah';
    _selectedMatkul = widget.matkulList.isNotEmpty ? widget.matkulList.first : null;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtaskCtrl.dispose();
    _customMatkulCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    color: widget.cardBorder,
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
                          color: widget.textPrimary,
                        ),
                      ),
                      Text(
                        'To-Do item dengan checklist & deadline',
                        style: TextStyle(fontSize: 11, color: widget.textSecondary),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: widget.surfaceSecondary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: widget.cardBorder),
                      ),
                      child: Icon(Icons.close_rounded, color: widget.textSecondary, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: widget.surfaceSecondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: widget.cardBorder),
                ),
                child: TextField(
                  controller: _titleCtrl,
                  autofocus: true,
                  style: TextStyle(color: widget.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Apa yang ingin diselesaikan?',
                    hintStyle: TextStyle(color: widget.textMuted, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Workspace Selection
              Text(
                'Kategori / Workspace',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: widget.textSecondary),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['Kuliah', 'Tugas Harian', 'Pribadi'].map((ws) {
                  final isSelected = _selectedWs == ws;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedWs = ws;
                      if (ws == 'Kuliah' && _selectedMatkul == null) {
                        _selectedMatkul = widget.matkulList.first;
                      }
                    }),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected ? widget.accentColor : widget.surfaceSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? widget.accentColor : widget.cardBorder,
                        ),
                      ),
                      child: Text(
                        ws,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : widget.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Mata Kuliah Selector
              if (_selectedWs == 'Kuliah') ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.menu_book_rounded, color: widget.accentColor, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'Pilih Mata Kuliah',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: widget.accentColor,
                          ),
                        ),
                      ],
                    ),
                    if (!_isAddingCustomMatkul)
                      GestureDetector(
                        onTap: () => setState(() => _isAddingCustomMatkul = true),
                        child: Text(
                          '+ Tambah Baru',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: widget.accentColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_isAddingCustomMatkul)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: widget.surfaceSecondary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: widget.accentColor),
                          ),
                          child: TextField(
                            controller: _customMatkulCtrl,
                            autofocus: true,
                            style: TextStyle(color: widget.textPrimary, fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'Nama mata kuliah baru...',
                              hintStyle: TextStyle(color: widget.textMuted, fontSize: 12),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          final name = _customMatkulCtrl.text.trim();
                          if (name.isNotEmpty) {
                            setState(() {
                              widget.matkulList.insert(0, name);
                              _selectedMatkul = name;
                              _customMatkulCtrl.clear();
                              _isAddingCustomMatkul = false;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            gradient: widget.accentGradient,
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
                      children: widget.matkulList.map((mk) {
                        final isSelected = _selectedMatkul == mk;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedMatkul = mk),
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? widget.accentColor.withOpacity(0.18) : widget.surfaceSecondary,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? widget.accentColor : widget.cardBorder,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  Icon(Icons.check_rounded, size: 12, color: widget.accentColor),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  mk,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? widget.accentColor : widget.textSecondary,
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
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: widget.textSecondary),
              ),
              const SizedBox(height: 8),
              Row(
                children: TaskPriority.values.map((p) {
                  final isSelected = _selectedPriority == p;
                  final names = {
                    TaskPriority.low: 'Rendah',
                    TaskPriority.medium: 'Sedang',
                    TaskPriority.high: 'Tinggi',
                    TaskPriority.urgent: 'Urgent',
                  };
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPriority = p),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? widget.accentColor : widget.surfaceSecondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? widget.accentColor : widget.cardBorder,
                          ),
                        ),
                        child: Text(
                          names[p]!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : widget.textSecondary,
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
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: widget.textSecondary),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: widget.accentColor,
                            surface: widget.cardBg,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() => _selectedDueDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: widget.surfaceSecondary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: widget.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, color: widget.accentColor, size: 16),
                      const SizedBox(width: 10),
                      Text(
                        '${_selectedDueDate.day}/${_selectedDueDate.month}/${_selectedDueDate.year}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: widget.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_drop_down_rounded, color: widget.textSecondary),
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
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: widget.textSecondary),
                  ),
                  Text(
                    '${_subtasks.length} item',
                    style: TextStyle(fontSize: 10, color: widget.textMuted),
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
                        color: widget.surfaceSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: widget.cardBorder),
                      ),
                      child: TextField(
                        controller: _subtaskCtrl,
                        style: TextStyle(color: widget.textPrimary, fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Tambah langkah subtask...',
                          hintStyle: TextStyle(color: widget.textMuted, fontSize: 12),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      final text = _subtaskCtrl.text.trim();
                      if (text.isNotEmpty) {
                        setState(() {
                          _subtasks.add(text);
                          _subtaskCtrl.clear();
                        });
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.accentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              if (_subtasks.isNotEmpty) ...[
                const SizedBox(height: 8),
                ..._subtasks.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.surfaceSecondary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: widget.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_box_outline_blank_rounded,
                            size: 16, color: widget.textSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(fontSize: 12, color: widget.textPrimary),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _subtasks.removeAt(idx)),
                          child: Icon(Icons.close_rounded, size: 16, color: widget.textMuted),
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
                    final title = _titleCtrl.text.trim();
                    if (title.isNotEmpty) {
                      final newTask = TaskModel(
                        id: DateTime.now().toString(),
                        title: title,
                        workspace: _selectedWs,
                        matkul: _selectedWs == 'Kuliah' ? _selectedMatkul : null,
                        priority: _selectedPriority,
                        status: TaskStatus.todo,
                        dueDate: _selectedDueDate,
                        subtasksTotal: _subtasks.isEmpty ? 1 : _subtasks.length,
                        subtasksDone: 0,
                        tags: [
                          'To-Do',
                          if (_selectedWs == 'Kuliah' && _selectedMatkul != null)
                            _selectedMatkul!,
                        ],
                      );
                      widget.onTaskCreated(newTask);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Tugas baru berhasil ditambahkan! ✓'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
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
  }
}

