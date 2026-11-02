import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildStatsRow()),
            SliverToBoxAdapter(child: _buildProductivityChart()),
            SliverToBoxAdapter(child: _buildTodayAgenda()),
            SliverToBoxAdapter(child: _buildRecentActivity()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.orangeGradient,
              border: Border.all(color: AppColors.primaryOrange.withOpacity(0.4), width: 2),
            ),
            child: const Center(
              child: Text('P', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selamat pagi 👋', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                const Text('Peter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ],
            ),
          ),
          // Notification Bell
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 22),
              ),
              Positioned(
                top: 10, right: 10,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: AppColors.primaryOrange, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Quick Stats Row ───────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    final stats = [
      _StatData('Tugas Selesai', '12', '/18', AppColors.success, AppColors.successSoft, Icons.check_circle_rounded),
      _StatData('Jadwal Hari Ini', '4', '', AppColors.info, AppColors.infoSoft, Icons.calendar_today_rounded),
      _StatData('Catatan Tersimpan', '47', '', AppColors.purple, AppColors.purpleSoft, Icons.sticky_note_2_rounded),
      _StatData('Pengingat Aktif', '3', '', AppColors.warning, AppColors.warningSoft, Icons.alarm_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan Hari Ini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.65,
            children: stats.map((s) => _StatCard(data: s)).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Productivity Chart ────────────────────────────────────────────────────
  Widget _buildProductivityChart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Produktivitas Mingguan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
                child: const Text('7 Hari', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('78%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      const Text('Rata-rata penyelesaian', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ]),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.successSoft, borderRadius: BorderRadius.circular(12)),
                      child: const Row(children: [
                        Icon(Icons.arrow_upward_rounded, color: AppColors.success, size: 14),
                        SizedBox(width: 3),
                        Text('+12%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success)),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const _BarChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Today's Agenda ────────────────────────────────────────────────────────
  Widget _buildTodayAgenda() {
    final agenda = [
      _AgendaItem('09:00', 'Standup Meeting Tim', 'Zoom · 30 menit', AppColors.info),
      _AgendaItem('11:00', 'Review Desain Alexa', 'Google Meet · 1 jam', AppColors.purple),
      _AgendaItem('14:00', 'Evaluasi Klien PT Maju', 'Offline · 2 jam', AppColors.primaryOrange),
      _AgendaItem('16:30', 'Sprint Planning', 'Zoom · 1 jam', AppColors.success),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Agenda Hari Ini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const Text('Lihat Semua', style: TextStyle(fontSize: 12, color: AppColors.primaryOrange, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          ...agenda.map((a) => _AgendaTile(item: a)),
        ],
      ),
    );
  }

  // ─── Recent Activity ───────────────────────────────────────────────────────
  Widget _buildRecentActivity() {
    final activities = [
      _ActivityData(Icons.check_circle_rounded, 'Tugas selesai', '"Buat mockup homepage Alexa"', AppColors.success, '2 menit lalu'),
      _ActivityData(Icons.mic_rounded, 'Alexa membuat jadwal', 'Meeting klien PT Maju besok 14:00', AppColors.primaryOrange, '15 menit lalu'),
      _ActivityData(Icons.sticky_note_2_rounded, 'Catatan baru disimpan', '"Materi REST API Design Pattern"', AppColors.purple, '1 jam lalu'),
      _ActivityData(Icons.alarm_rounded, 'Pengingat dikirim', 'Sprint review pukul 14:00', AppColors.warning, '2 jam lalu'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Aktivitas Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: activities.asMap().entries.map((e) {
                final isLast = e.key == activities.length - 1;
                return _ActivityTile(data: e.value, isLast: isLast);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────

class _StatData {
  final String label;
  final String value;
  final String suffix;
  final Color color;
  final Color softColor;
  final IconData icon;
  const _StatData(this.label, this.value, this.suffix, this.color, this.softColor, this.icon);
}

class _AgendaItem {
  final String time;
  final String title;
  final String subtitle;
  final Color color;
  const _AgendaItem(this.time, this.title, this.subtitle, this.color);
}

class _ActivityData {
  final IconData icon;
  final String action;
  final String detail;
  final Color color;
  final String time;
  const _ActivityData(this.icon, this.action, this.detail, this.color, this.time);
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final _StatData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: data.softColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(data.icon, color: data.color, size: 18),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(data.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Text(data.suffix, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
            ]),
            const SizedBox(height: 2),
            Text(data.label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
          ]),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final values = [0.65, 0.80, 0.55, 0.90, 0.70, 0.40, 0.78];
    final today = 6;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(days.length, (i) {
        final isToday = i == today;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 400 + (i * 60)),
                  height: 80 * values[i],
                  decoration: BoxDecoration(
                    gradient: isToday ? AppColors.orangeGradient : null,
                    color: isToday ? null : AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isToday ? [const BoxShadow(color: AppColors.primaryOrangeGlow, blurRadius: 10, offset: Offset(0, 4))] : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(days[i], style: TextStyle(fontSize: 10, fontWeight: isToday ? FontWeight.w700 : FontWeight.w400, color: isToday ? AppColors.primaryOrange : AppColors.textMuted)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _AgendaTile extends StatelessWidget {
  final _AgendaItem item;
  const _AgendaTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 40, decoration: BoxDecoration(color: item.color, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.time, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: item.color)),
          ]),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text(item.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ])),
          Container(width: 8, height: 8, decoration: BoxDecoration(color: item.color, shape: BoxShape.circle)),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final _ActivityData data;
  final bool isLast;
  const _ActivityTile({required this.data, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.color, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data.action, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 3),
            Text(data.detail, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          Text(data.time, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

