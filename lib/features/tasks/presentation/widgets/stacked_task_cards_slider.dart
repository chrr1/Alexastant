import 'package:flutter/material.dart';
import '../../domain/models/task_model.dart';

/// Ultra-Lightweight 120FPS Finger-Tracking Stacked Deck Slider:
/// - Menggunakan ValueNotifier (Zero-rebuild overhead saat jari bergerak).
/// - Tinggi kartu konsisten (Strip kalender di bawah diam stabil, tidak naik-turun).
/// - Kartu belakang mengintip dengan jelas di atas kartu depan dengan bayangan kontras.
class StackedTaskCardsSlider extends StatefulWidget {
  final bool isDark;
  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onToggleTaskComplete;
  final Function(TaskModel task, SubtaskItem subtask) onToggleSubtask;
  final ValueChanged<TaskModel> onEditTask;

  const StackedTaskCardsSlider({
    super.key,
    required this.isDark,
    required this.tasks,
    required this.onToggleTaskComplete,
    required this.onToggleSubtask,
    required this.onEditTask,
  });

  @override
  State<StackedTaskCardsSlider> createState() => _StackedTaskCardsSliderState();
}

class _StackedTaskCardsSliderState extends State<StackedTaskCardsSlider>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  // ValueNotifier untuk pergerakan jari (Tidak memicu setState widget tree)
  final ValueNotifier<double> _dragNotifier = ValueNotifier<double>(0.0);

  late AnimationController _animController;
  Animation<double>? _animOffset;

  // Tinggi kartu yang seragam agar elemen di bawahnya (kalender) tidak naik-turun
  static const double _cardHeight = 310.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _animController.addListener(() {
      if (_animOffset != null) {
        _dragNotifier.value = _animOffset!.value;
      }
    });

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_dragNotifier.value.abs() > 100) {
          setState(() {
            if (widget.tasks.isNotEmpty) {
              _currentIndex = (_currentIndex + 1) % widget.tasks.length;
            }
          });
          _dragNotifier.value = 0.0;
        } else {
          _dragNotifier.value = 0.0;
        }
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _dragNotifier.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    if (_animController.isAnimating) _animController.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (widget.tasks.length <= 1) return;
    _dragNotifier.value += details.delta.dx;
  }

  void _onDragEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final velocity = details.primaryVelocity ?? 0.0;
    final currentOffset = _dragNotifier.value;

    final shouldDismiss = currentOffset.abs() > 70 || velocity.abs() > 300;

    if (shouldDismiss && widget.tasks.length > 1) {
      final direction = currentOffset != 0 ? currentOffset.sign : (velocity < 0 ? -1.0 : 1.0);
      final targetOffset = direction * (screenWidth * 1.05);

      _animOffset = Tween<double>(begin: currentOffset, end: targetOffset).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
      );
      _animController.forward(from: 0.0);
    } else {
      _animOffset = Tween<double>(begin: currentOffset, end: 0.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
      );
      _animController.forward(from: 0.0);
    }
  }

  void _nextCardProgrammatic() {
    if (_animController.isAnimating || widget.tasks.length <= 1) return;
    final screenWidth = MediaQuery.of(context).size.width;
    _animOffset = Tween<double>(begin: 0.0, end: -screenWidth * 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tasks.isEmpty) {
      return Container(
        height: _cardHeight,
        alignment: Alignment.center,
        child: const Text('Tidak ada tugas untuk hari ini'),
      );
    }

    final currentTask = widget.tasks[_currentIndex % widget.tasks.length];
    final hasNext = widget.tasks.length > 1;
    final nextTask = hasNext
        ? widget.tasks[(_currentIndex + 1) % widget.tasks.length]
        : null;

    // Wadah dengan tinggi tetap + ruang 18px di atas untuk preview kartu yang mengintip
    return SizedBox(
      height: _cardHeight + 20, // 20px headroom untuk kartu yang mengintip
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        behavior: HitTestBehavior.opaque,
        child: ValueListenableBuilder<double>(
          valueListenable: _dragNotifier,
          builder: (context, dragOffset, _) {
            final dragRatio = (dragOffset.abs() / 200.0).clamp(0.0, 1.0);
            final rotationAngle = (dragOffset / 900.0).clamp(-0.14, 0.14);

            // Kartu belakang bertransformasi mulus:
            // Scale: 0.93 -> 1.0
            // Offset Y: dari -16px (mengintip di atas) -> 0px
            final backCardScale = 0.93 + (0.07 * dragRatio);
            final backCardOffsetY = -16.0 * (1.0 - dragRatio);
            final backCardOpacity = (0.75 + (0.25 * dragRatio)).clamp(0.0, 1.0);

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // ─── 1. KARTU BELAKANG (Mengintip jelas di atas dengan bayangan) ───
                if (hasNext && nextTask != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(0, backCardOffsetY),
                      child: Transform.scale(
                        scale: backCardScale,
                        child: Opacity(
                          opacity: backCardOpacity,
                          child: IgnorePointer(
                            child: _buildFullTaskCard(
                              task: nextTask,
                              isFront: false,
                              taskIndex: (_currentIndex + 1) % widget.tasks.length,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // ─── 2. KARTU DEPAN (Mengikuti Jari Ringan 120fps) ────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(dragOffset, 0),
                    child: Transform.rotate(
                      angle: rotationAngle,
                      child: _buildFullTaskCard(
                        task: currentTask,
                        isFront: true,
                        taskIndex: _currentIndex % widget.tasks.length,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ─── TEMPLATE KARTU DENGAN TINGGI STABIL & PREVIEW JELAS ──────────────────
  Widget _buildFullTaskCard({
    required TaskModel task,
    required bool isFront,
    required int taskIndex,
  }) {
    Color priorityColor;
    String priorityLabel;
    switch (task.priority) {
      case TaskPriority.urgent:
        priorityColor = const Color(0xFFEF4444);
        priorityLabel = 'Urgent';
        break;
      case TaskPriority.high:
        priorityColor = const Color(0xFFF97316);
        priorityLabel = 'High';
        break;
      case TaskPriority.medium:
        priorityColor = const Color(0xFF3B82F6);
        priorityLabel = 'Medium';
        break;
      case TaskPriority.low:
        priorityColor = const Color(0xFF10B981);
        priorityLabel = 'Low';
        break;
    }

    final dueTimeString = task.dueDate != null
        ? '${task.dueDate!.hour.toString().padLeft(2, '0')}:${task.dueDate!.minute.toString().padLeft(2, '0')}'
        : '17:00';

    final categoryLabel = task.matkul ?? task.workspace;

    return Container(
      height: _cardHeight,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: isFront ? Colors.white : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isFront ? Colors.transparent : Colors.white.withOpacity(0.9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(isFront ? 0.08 : 0.05),
            blurRadius: isFront ? 20 : 12,
            offset: Offset(0, isFront ? 6 : -3), // -3 membuat bayangan mengintip di atas
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header: Category + Priority + Edit + Checkbox ────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    const Text(
                      "Today's focus",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                        letterSpacing: -0.1,
                      ),
                    ),
                    if (categoryLabel.isNotEmpty) ...[
                      const Text(
                        "•",
                        style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1)),
                      ),
                      Text(
                        categoryLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        priorityLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: priorityColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (isFront)
                GestureDetector(
                  onTap: () => widget.onEditTask(task),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF1F5F9),
                    ),
                    child: const Icon(Icons.more_horiz_rounded, size: 17, color: Color(0xFF64748B)),
                  ),
                ),

              GestureDetector(
                onTap: isFront ? () => widget.onToggleTaskComplete(task) : null,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.status == TaskStatus.completed
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF1F5F9),
                    border: Border.all(
                      color: task.status == TaskStatus.completed
                          ? const Color(0xFF10B981)
                          : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    task.status == TaskStatus.completed ? Icons.check_rounded : Icons.check_rounded,
                    size: 15,
                    color: task.status == TaskStatus.completed ? Colors.white : Colors.transparent,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ─── Title & Description ──────────────────────────────────────────
          Text(
            task.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              height: 1.25,
              letterSpacing: -0.4,
            ),
          ),

          if (task.description != null && task.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              task.description!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
                height: 1.35,
              ),
            ),
          ],

          const SizedBox(height: 10),

          // ─── Subtasks Area (Expanded/Flexible agar mengisi ruang seragam) ─
          Expanded(
            child: task.subtasks.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'SUBTASKS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '${task.doneSubtasksCount}/${task.totalSubtasksCount} selesai',
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: task.totalSubtasksCount > 0
                                ? task.doneSubtasksCount / task.totalSubtasksCount
                                : 0.0,
                            minHeight: 3.5,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF50689C)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: task.subtasks.take(2).map((subtask) {
                              return GestureDetector(
                                onTap: isFront ? () => widget.onToggleSubtask(task, subtask) : null,
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        subtask.isCompleted
                                            ? Icons.check_circle_rounded
                                            : Icons.radio_button_unchecked_rounded,
                                        size: 15,
                                        color: subtask.isCompleted
                                            ? const Color(0xFF10B981)
                                            : const Color(0xFF94A3B8),
                                      ),
                                      const SizedBox(width: 7),
                                      Expanded(
                                        child: Text(
                                          subtask.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: subtask.isCompleted
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF1E293B),
                                            decoration: subtask.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
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
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 12),

          // ─── Bottom Info: Deadline & Indicator ────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.notifications_active_rounded, size: 13, color: Color(0xFFEF4444)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Tenggat $dueTimeString WIB',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFB91C1C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              GestureDetector(
                onTap: isFront ? _nextCardProgrammatic : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${taskIndex + 1}/${widget.tasks.length}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF475569)),
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
}
