import 'package:flutter/material.dart';
import 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';

class CalendarSamsungData {
  // Palet Warna Khas Kalender Samsung (Soft Pastel Blocks)
  static const Color yellowEvent = Color(0xFFFACC15);     // Kuning Tugas & Laprak
  static const Color purpleEvent = Color(0xFFA78BFA);     // Lavender Praktikum & Kelas
  static const Color greenEvent = Color(0xFFA3E635);      // Hijau Lime UTS & Akademik
  static const Color redEvent = Color(0xFFF87171);        // Coral / Pinkish Rapat & Pertemuan
  static const Color cyanEvent = Color(0xFF38BDF8);       // Cyan HIMA & Kegiatan
  static const Color blueEvent = Color(0xFF60A5FA);       // Biru Webinar
  static const Color darkRedEvent = Color(0xFF991B1B);    // Maroon Spesial

  // Daftar Kategori Samsung One UI (Sesuai Gambar 2)
  static List<CalendarCategoryItem> getDefaultCategories() {
    return [
      const CalendarCategoryItem(
        id: 'c1',
        name: 'Pengingat saya',
        color: Color(0xFF8B5CF6),
        icon: Icons.notifications_rounded,
        count: 7,
      ),
      const CalendarCategoryItem(
        id: 'c2',
        name: 'TUGAS',
        color: Color(0xFFF59E0B),
        icon: Icons.notifications_rounded,
        count: 3,
      ),
      const CalendarCategoryItem(
        id: 'c3',
        name: 'Kategori 2',
        color: Color(0xFFEF4444),
        icon: Icons.notifications_rounded,
        count: 0,
      ),
      const CalendarCategoryItem(
        id: 'c4',
        name: 'gereja',
        color: Color(0xFFA855F7),
        icon: Icons.notifications_rounded,
        count: 0,
      ),
      const CalendarCategoryItem(
        id: 'c5',
        name: 'hima',
        color: Color(0xFF06B6D4),
        icon: Icons.notifications_rounded,
        count: 5,
      ),
      const CalendarCategoryItem(
        id: 'c6',
        name: 'UAS',
        color: Color(0xFF84CC16),
        icon: Icons.notifications_rounded,
        count: 0,
      ),
      const CalendarCategoryItem(
        id: 'c7',
        name: 'webinar',
        color: Color(0xFF3B82F6),
        icon: Icons.notifications_rounded,
        count: 0,
      ),
      const CalendarCategoryItem(
        id: 'c8',
        name: 'safevol',
        color: Color(0xFF84CC16),
        icon: Icons.notifications_rounded,
        count: 0,
      ),
      const CalendarCategoryItem(
        id: 'c9',
        name: 'safevolution fns',
        color: Color(0xFFC084FC),
        icon: Icons.notifications_rounded,
        count: 0,
      ),
      const CalendarCategoryItem(
        id: 'c10',
        name: 'BU',
        color: Color(0xFF0284C7),
        icon: Icons.menu_book_rounded,
        count: 0,
      ),
      const CalendarCategoryItem(
        id: 'c11',
        name: 'Kategori 1',
        color: Color(0xFF38BDF8),
        icon: Icons.cake_rounded,
        count: 1,
      ),
    ];
  }

  // Data Agenda Oktober Lengkap (Sesuai Gambar 3)
  static Map<int, List<CalendarEventItem>> getOctoberEvents() {
    return {
      1: [
        CalendarEventItem(
          id: '1-1',
          title: 'ppt erp',
          time: '08:00 - 09:30',
          duration: '1.5 jam',
          location: 'Lab Komputer 3',
          color: yellowEvent,
          category: 'TUGAS',
        ),
        CalendarEventItem(
          id: '1-2',
          title: 'ppt rab es-acara',
          time: '10:00 - 11:30',
          duration: '1.5 jam',
          location: 'Ruang HIMA',
          color: purpleEvent,
          category: 'hima',
        ),
        CalendarEventItem(
          id: '1-3',
          title: 'rabes-k le',
          time: '13:00 - 14:30',
          duration: '1.5 jam',
          location: 'Gedung Dekanat Lt.2',
          color: redEvent,
          category: 'Pengingat saya',
        ),
      ],
      2: [
        CalendarEventItem(
          id: '2-1',
          title: 'tugas s td',
          time: '09:00 - 11:00',
          duration: '2 jam',
          location: 'Perpustakaan',
          color: yellowEvent,
          category: 'TUGAS',
        ),
      ],
      3: [
        CalendarEventItem(
          id: '3-1',
          title: 'technical meeting',
          time: '14:00 - 16:00',
          duration: '2 jam',
          location: 'Aula Utama',
          color: redEvent,
          category: 'hima',
        ),
      ],
      4: [
        CalendarEventItem(
          id: '4-1',
          title: 'rapat GSM',
          time: '19:00 - 20:30',
          duration: '1.5 jam',
          location: 'Google Meet',
          color: purpleEvent,
          category: 'Pengingat saya',
        ),
      ],
      5: [
        CalendarEventItem(
          id: '5-1',
          title: 'praktikum audio',
          time: '08:00 - 10:00',
          duration: '2 jam',
          location: 'Lab Multimedia',
          color: purpleEvent,
          category: 'Kuliah',
        ),
        CalendarEventItem(
          id: '5-2',
          title: 'tugas k w topik',
          time: '13:30 - 15:00',
          duration: '1.5 jam',
          location: 'Online Classroom',
          color: yellowEvent,
          category: 'TUGAS',
        ),
      ],
      6: [
        CalendarEventItem(
          id: '6-1',
          title: 'pak uts',
          time: '09:00 - 10:30',
          duration: '1.5 jam',
          location: 'Ruang Ujian A',
          color: greenEvent,
          category: 'UAS',
        ),
        CalendarEventItem(
          id: '6-2',
          title: 'presentasi dan is...',
          time: '11:00 - 12:30',
          duration: '1.5 jam',
          location: 'Auditorium',
          color: yellowEvent,
          category: 'TUGAS',
        ),
      ],
      7: [
        CalendarEventItem(
          id: '7-1',
          title: 'std uts',
          time: '10:00 - 12:00',
          duration: '2 jam',
          location: 'Ruang Ujian B',
          color: greenEvent,
          category: 'UAS',
        ),
      ],
      8: [
        CalendarEventItem(
          id: '8-1',
          title: 'uts mekanik',
          time: '08:00 - 10:00',
          duration: '2 jam',
          location: 'Ruang Ujian C',
          color: greenEvent,
          category: 'UAS',
        ),
      ],
      9: [
        CalendarEventItem(
          id: '9-1',
          title: 'pl-ml uts',
          time: '13:00 - 15:00',
          duration: '2 jam',
          location: 'Lab Komputer 1',
          color: greenEvent,
          category: 'UAS',
        ),
      ],
      10: [
        CalendarEventItem(
          id: '10-1',
          title: 'kic',
          time: '16:00 - 17:30',
          duration: '1.5 jam',
          location: 'Studio Musik',
          color: redEvent,
          category: 'Pengingat saya',
        ),
      ],
      11: [
        CalendarEventItem(
          id: '11-1',
          title: 'kic',
          time: '15:00 - 17:00',
          duration: '2 jam',
          location: 'Studio Musik',
          color: redEvent,
          category: 'Pengingat saya',
        ),
      ],
      12: [
        CalendarEventItem(
          id: '12-1',
          title: 'laprak pkk',
          time: '09:00 - 11:00',
          duration: '2 jam',
          location: 'Lab Terpadu',
          color: yellowEvent,
          category: 'TUGAS',
        ),
        CalendarEventItem(
          id: '12-2',
          title: 'uts pkk',
          time: '13:00 - 14:30',
          duration: '1.5 jam',
          location: 'Ruang 204',
          color: greenEvent,
          category: 'UAS',
        ),
      ],
      13: [
        CalendarEventItem(
          id: '13-1',
          title: 'hifb uts',
          time: '10:00 - 12:00',
          duration: '2 jam',
          location: 'Ruang 301',
          color: greenEvent,
          category: 'UAS',
        ),
      ],
      15: [
        CalendarEventItem(
          id: '15-1',
          title: 'kelas pengganti',
          time: '08:00 - 10:00',
          duration: '2 jam',
          location: 'Gedung A Lt.3',
          color: purpleEvent,
          category: 'Kuliah',
        ),
        CalendarEventItem(
          id: '15-2',
          title: 'uts toksikologi',
          time: '11:00 - 12:30',
          duration: '1.5 jam',
          location: 'Ruang 102',
          color: greenEvent,
          category: 'UAS',
        ),
      ],
      16: [
        CalendarEventItem(
          id: '16-1',
          title: 'kelas pengganti',
          time: '13:00 - 15:00',
          duration: '2 jam',
          location: 'Gedung B Lt.2',
          color: purpleEvent,
          category: 'Kuliah',
        ),
      ],
      18: [
        CalendarEventItem(
          id: '18-1',
          title: 'HOC',
          time: '09:00 - 12:00',
          duration: '3 jam',
          location: 'Sekretariat HIMA',
          color: cyanEvent,
          category: 'hima',
        ),
      ],
      19: [
        CalendarEventItem(
          id: '19-1',
          title: 'praktikum spiron',
          time: '08:00 - 10:00',
          duration: '2 jam',
          location: 'Lab Faal',
          color: purpleEvent,
          category: 'Kuliah',
        ),
        CalendarEventItem(
          id: '19-2',
          title: 'minta t td mas yo',
          time: '11:00 - 12:00',
          duration: '1 jam',
          location: 'Ruang Dosen',
          color: purpleEvent,
          category: 'Pengingat saya',
        ),
      ],
      22: [
        CalendarEventItem(
          id: '22-1',
          title: 'case method (kuliah)',
          time: '08:00 - 10:30',
          duration: '2.5 jam',
          location: 'Ruang Diskusi',
          color: redEvent,
          category: 'Kuliah',
        ),
        CalendarEventItem(
          id: '22-2',
          title: 'kelas toksiko',
          time: '11:00 - 12:30',
          duration: '1.5 jam',
          location: 'Ruang Kuliah 4',
          color: purpleEvent,
          category: 'Kuliah',
        ),
        CalendarEventItem(
          id: '22-3',
          title: 'tm-me echa',
          time: '14:00 - 15:30',
          duration: '1.5 jam',
          location: 'Kantin Pusat',
          color: cyanEvent,
          category: 'hima',
        ),
      ],
      23: [
        CalendarEventItem(
          id: '23-1',
          title: 'pengganti matkul',
          time: '10:00 - 12:00',
          duration: '2 jam',
          location: 'Gedung C Lt.1',
          color: purpleEvent,
          category: 'Kuliah',
        ),
      ],
      25: [
        CalendarEventItem(
          id: '25-1',
          title: 'mulmed',
          time: '13:00 - 15:00',
          duration: '2 jam',
          location: 'Lab Multimedia',
          color: purpleEvent,
          category: 'Kuliah',
        ),
      ],
      26: [
        CalendarEventItem(
          id: '26-1',
          title: 'laprak mekanik-t',
          time: '08:00 - 10:00',
          duration: '2 jam',
          location: 'Lab Fisika',
          color: yellowEvent,
          category: 'TUGAS',
        ),
        CalendarEventItem(
          id: '26-2',
          title: 'laprak spirometri',
          time: '10:30 - 12:00',
          duration: '1.5 jam',
          location: 'Lab Faal',
          color: yellowEvent,
          category: 'TUGAS',
        ),
        CalendarEventItem(
          id: '26-3',
          title: 'belajar media and',
          time: '14:00 - 16:00',
          duration: '2 jam',
          location: 'Perpustakaan',
          color: purpleEvent,
          category: 'Pengingat saya',
        ),
      ],
      27: [
        CalendarEventItem(
          id: '27-1',
          title: 'pdf PAK',
          time: '09:00 - 10:30',
          duration: '1.5 jam',
          location: 'Online Submissions',
          color: yellowEvent,
          category: 'TUGAS',
        ),
        CalendarEventItem(
          id: '27-2',
          title: 'tm-magang',
          time: '13:00 - 14:30',
          duration: '1.5 jam',
          location: 'Zoom Meeting',
          color: cyanEvent,
          category: 'hima',
        ),
      ],
      29: [
        CalendarEventItem(
          id: '29-1',
          title: 'tugas KWU',
          time: '08:30 - 10:30',
          duration: '2 jam',
          location: 'Gedung Bisnis',
          color: yellowEvent,
          category: 'TUGAS',
        ),
        CalendarEventItem(
          id: '29-2',
          title: 'konsul maket',
          time: '11:00 - 12:30',
          duration: '1.5 jam',
          location: 'Studio Arsitektur',
          color: yellowEvent,
          category: 'TUGAS',
        ),
      ],
      30: [
        CalendarEventItem(
          id: '30-1',
          title: 'maket b3-pl',
          time: '09:00 - 11:00',
          duration: '2 jam',
          location: 'Studio Maket',
          color: yellowEvent,
          category: 'TUGAS',
        ),
        CalendarEventItem(
          id: '30-2',
          title: 'cm-pi-d an-hifb',
          time: '11:30 - 13:00',
          duration: '1.5 jam',
          location: 'Ruang 103',
          color: purpleEvent,
          category: 'Pengingat saya',
        ),
        CalendarEventItem(
          id: '30-3',
          title: 'rabes moccha-d',
          time: '15:00 - 17:00',
          duration: '2 jam',
          location: 'Kafe Kampus',
          color: cyanEvent,
          category: 'hima',
        ),
      ],
    };
  }
}

