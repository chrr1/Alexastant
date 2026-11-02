import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class NewTaskFormScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onTaskCreated;

  const NewTaskFormScreen({super.key, this.onTaskCreated});

  @override
  State<NewTaskFormScreen> createState() => _NewTaskFormScreenState();
}

class _NewTaskFormScreenState extends State<NewTaskFormScreen> {
  final TextEditingController _titleController =
      TextEditingController(text: 'Task Planner Mobile Apps');
  final TextEditingController _descController = TextEditingController(
    text:
        'Task Planner apps with simple and modern style which is like in the references, after that need to post on Dribbble at 2.50PM, but remember after done making the design always consult first to your supervisor.',
  );

  String _dueDate = '22 May';
  String _endDate = '04 June';
  String _dailyTimeline = '10.00 - 12.00 (2h)';
  String _selectedWorkspace = 'Proyek Kuliah';

  final List<String> _workspaces = [
    'Proyek Kuliah',
    'Tugas Harian',
    'Shared Workspace',
    'Private Workspace',
    'Mick Task Project',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul jadwal/tugas tidak boleh kosong'),
          backgroundColor: AppColors.primaryOrange,
        ),
      );
      return;
    }

    final taskData = {
      'title': _titleController.text,
      'description': _descController.text,
      'dueDate': _dueDate,
      'endDate': _endDate,
      'dailyTimeline': _dailyTimeline,
      'workspace': _selectedWorkspace,
    };

    widget.onTaskCreated?.call(taskData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Jadwal baru berhasil dibuat secara manual!'),
        backgroundColor: AppColors.primaryOrange,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'New Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  _buildCircleButton(
                    icon: Icons.more_horiz_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Form Fields Scrollable
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Field
                    _buildLabel('Tittle'),
                    _buildTextField(
                      controller: _titleController,
                      hint: 'Enter task title...',
                    ),

                    const SizedBox(height: 18),

                    // Description Field
                    _buildLabel('Description'),
                    _buildTextField(
                      controller: _descController,
                      hint: 'Enter task description...',
                      maxLines: 5,
                    ),

                    const SizedBox(height: 18),

                    // Due date & End date row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Due date'),
                              _buildDatePickerBox(
                                value: _dueDate,
                                onTap: () => _pickDate(true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('End date'),
                              _buildDatePickerBox(
                                value: _endDate,
                                onTap: () => _pickDate(false),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Daily timeline
                    _buildLabel('Daily timeline'),
                    _buildTimelinePickerBox(),

                    const SizedBox(height: 18),

                    // Workspace Dropdown
                    _buildLabel('Workspace'),
                    _buildWorkspaceDropdown(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Bottom CTA Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _submitTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 6,
                    shadowColor: AppColors.primaryOrangeGlow,
                  ),
                  child: const Text(
                    'Create',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 13,
          height: 1.45,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDatePickerBox({
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelinePickerBox() {
    return GestureDetector(
      onTap: () {
        // Toggle time range
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dailyTimeline,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.access_time_rounded,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkspaceDropdown() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedWorkspace,
          dropdownColor: AppColors.surfaceSecondary,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
          ),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w500,
          ),
          items: _workspaces.map((ws) {
            return DropdownMenuItem<String>(
              value: ws,
              child: Text(ws),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedWorkspace = val);
            }
          },
        ),
      ),
    );
  }

  void _pickDate(bool isDue) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryOrange,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'June',
        'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
      ];
      final formatted = '${picked.day} ${months[picked.month - 1]}';
      setState(() {
        if (isDue) {
          _dueDate = formatted;
        } else {
          _endDate = formatted;
        }
      });
    }
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(
          icon,
          color: AppColors.textPrimary,
          size: 18,
        ),
      ),
    );
  }
}

