import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';
import 'package:alexa/features/calendar/presentation/screens/new_task_form_screen.dart';

class CalendarAddFab extends StatelessWidget {
  const CalendarAddFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 84.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewTaskFormScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            gradient: AppColors.orangeGradient,
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [
              BoxShadow(
                color: AppColors.primaryOrangeGlow,
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add_rounded, color: Colors.white, size: 18),
              SizedBox(width: 5),
              Text(
                'Tambah Jadwal',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
