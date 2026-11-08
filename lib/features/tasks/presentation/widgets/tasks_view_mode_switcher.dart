import 'package:flutter/material.dart';
import '../../domain/models/task_model.dart';

class TasksViewModeSwitcher extends StatelessWidget {
  final TasksViewMode viewMode;
  final ValueChanged<TasksViewMode> onChanged;
  final Color cardBorder;
  final Color cardInnerBg;
  final Color accentColor;
  final Color accentGlow;
  final Color textSecondary;

  const TasksViewModeSwitcher({
    super.key,
    required this.viewMode,
    required this.onChanged,
    required this.cardBorder,
    required this.cardInnerBg,
    required this.accentColor,
    required this.accentGlow,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cardInnerBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          _buildButton('Bento Proyek', TasksViewMode.bentoWorkspaces, Icons.grid_view_rounded),
          _buildButton('Kanban Board', TasksViewMode.kanban, Icons.view_column_rounded),
          _buildButton('Daftar Semua', TasksViewMode.allList, Icons.format_list_bulleted_rounded),
        ],
      ),
    );
  }

  Widget _buildButton(String title, TasksViewMode mode, IconData icon) {
    final isSelected = viewMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(mode),
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
}

