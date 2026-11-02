import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DeviceCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool initialStatus;

  const DeviceCard({
    super.key,
    this.title = 'Samsung Smart TV',
    this.subtitle = 'Family room',
    this.initialStatus = true,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tv_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
              const Icon(
                Icons.more_horiz_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isOn ? 'On' : 'Off',
                    style: TextStyle(
                      color: _isOn ? AppColors.textPrimary : AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.75,
                    child: CupertinoSwitch(
                      activeColor: AppColors.primaryOrange,
                      trackColor: AppColors.surfaceSecondary,
                      value: _isOn,
                      onChanged: (val) {
                        setState(() => _isOn = val);
                      },
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
}

