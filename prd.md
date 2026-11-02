# PRODUCT REQUIREMENTS DOCUMENT (PRD)
## Alexa – AI Personal Productivity Assistant

**Nama Produk:** Alexa  
**Versi:** 2.0 (Updated Branding)  
**Status:** Approved for Development  
**Tanggal Rilis Dokumen:** 2026-11-02  
**Platform Target:** Mobile Application (Android & iOS)  
**Tech Stack Utama:**
- **Frontend:** Flutter (Dart) — State Management: Riverpod / BLoC
- **Backend:** Python FastAPI (Asynchronous REST API & WebSockets)
- **Database & Auth:** Supabase (PostgreSQL 15+, Supabase Auth JWT, Row Level Security, pgvector, Realtime)
- **AI Engine:** Google Gemini API (Gemini 1.5/2.0 Flash/Pro with Structured Outputs & Function Calling)
- **Push Notifications:** Firebase Cloud Messaging (FCM) + Background Worker

---

## 1. Executive Summary & Product Overview

### 1.1. Deskripsi Produk
**Alexa** adalah aplikasi asisten pribadi mobile lintas platform cerdas yang menggabungkan kekuatan percakapan berbasis Natural Language Processing (Google Gemini) dengan sistem manajemen produktivitas terintegrasi (Task, Calendar, Reminder, Smart Notes/Second Brain).

Alexa bukan sekadar chatbot pasif yang hanya menjawab pertanyaan umum, melainkan **Action-Oriented Conversational Agent** yang memiliki otoritas mengeksekusi operasi produktivitas pengguna secara langsung (*Function Calling/Tool Use*) melalui bahasa percakapan sehari-hari (Bahasa Indonesia & Bahasa Inggris).

### 1.2. Problem Statement
Saat ini, produktivitas personal terhambat oleh fenomena *app fatigue* dan *fragmentasi informasi*:
1. **Fragmentasi Data:** Pengguna memakai rata-rata 3–4 aplikasi berbeda (To-Do app, Google Calendar, Notes app, Reminder app) yang tidak saling berkomunikasi.
2. **Beban Input Manual (High Friction):** Menjadwalkan rapat, mencatat tugas berulang, dan membuat alarm memerlukan navigasi form input berjenjang yang memakan waktu.
3. **Kehilangan Konteks (Information Silos):** Catatan rapat seringkali terpisah dari tugas tindak lanjut (*action items*) dan tanggal deadline di kalender.
4. **Asisten Tradisional Kurang Kontekstual:** Asisten suara bawaan ponsel sering kali kaku, tidak memiliki ingatan (*long-term context memory*), dan gagal memproses instruksi bertingkat (*multi-step commands*).

### 1.3. Product Vision & Value Proposition
- **Vision:** Menjadi "Second Brain" dan manajer pribadi otonom bagi setiap individu untuk mengotomatisasi pengorganisasian hidup dan pekerjaan sehari-hari.
- **Value Proposition:**
  - *Zero-Friction Productivity:* Cukup ketik atau bicara, Alexa mengekstrak entitas (waktu, prioritas, kategori) dan menyimpannya ke modul terkait.
  - *Connected Intelligence:* Satu catatan rapat dapat otomatis menghasilkan daftar *to-do item* dan jadwal kalender.
  - *Proaktif, Bukan Hanya Reaktif:* Memberikan *Daily Morning Briefing* dan deteksi konflik jadwal secara otomatis.

---

## 2. Product Goals & Success Metrics

### 2.1. Product Goals
1. Mengurangi waktu pengguna dalam mencatat dan menjadwalkan aktivitas hingga 60% dibanding input manual konvensional.
2. Menyediakan ekosistem terpadu (*All-in-One Workspace*) di ponsel tanpa perlu berpindah-pindah aplikasi.
3. Memastikan tingkat akurasi pemahaman instruksi AI (*Tool Calling Accuracy*) di atas 95%.
4. Menyediakan sistem pencarian informasi instan (*Semantic Search*) berbasis vektor untuk seluruh riwayat catatan dan aktivitas pengguna.

### 2.2. Key Performance Indicators (KPIs)
| Metrik | Target MVP (Bulan 1-3) | Target Pertumbuhan (Bulan 6) |
| :--- | :--- | :--- |
| **User Retention (D30)** | > 35% | > 45% |
| **Tool Calling Execution Accuracy** | > 92% | > 97% |
| **AI Action Latency (End-to-End)** | < 1.8 detik | < 1.2 detik |
| **Daily Active Users (DAU) Engagement** | Rata-rata 4 interaksi/hari | Rata-rata 7 interaksi/hari |
| **Task Completion Rate** | > 70% dari tugas yang dibuat | > 80% dari tugas yang dibuat |

---

## 3. User Personas & Core Use Cases

### 3.1. User Personas
1. **Rian (26) – Professional / Product Manager:**
   - *Pain Points:* Jadwal meeting padat, banyak catatan brief tercecer di berbagai aplikasi, butuh pengingat follow-up sebelum meeting dimulai.
   - *Kebutuhan:* Memasukkan agenda lewat voice note singkat di sela perjalanan, rangkuman jadwal pagi hari (*morning briefing*).
2. **Nadia (21) – Mahasiswi Tingkat Akhir:**
   - *Pain Points:* Tugas kuliah dengan berbagai deadline, bahan riset skripsi berantakan, sering menunda karena lupa prioritas.
   - *Kebutuhan:* Manajemen to-do list dengan prioritas otomatis, pencarian catatan materi kuliah dengan bahasa alami.
3. **Budi (34) – Freelancer / Solopreneur:**
   - *Pain Points:* Menangani multi-klien sekaligus, invoice deadline, dan reminder pembayaran.
   - *Kebutuhan:* Asisten yang bisa mengingat konteks proyek klien dan mengecek ketersediaan jam luang di kalender.

### 3.2. Core User Scenarios
- **Scenario A (Compound Action):** Pengguna mengirim pesan: *"Besok jam 2 siang ada evaluasi mingguan dengan klien PT Maju. Ingatkan 1 jam sebelumnya dan catat bahwa kita harus bawa laptop backup."*
  - AI memanggil `create_calendar_event` (pukul 14:00 - 15:00).
  - AI memanggil `create_reminder` (pukul 13:00).
  - AI memanggil `create_note` terkait checklist laptop backup dengan tag `PT Maju`.
- **Scenario B (Natural Query):** Pengguna bertanya: *"Kapan terakhir kali aku rapat sama Tim Marketing, dan apa catatan pentingnya?"*
  - AI melakukan pencarian semantik pada database catatan dan mengembalikan jawaban komprehensif.

---

## 4. System Architecture & Tech Stack Details

### 4.1. Diagram Alur Arsitektur Sistem
```
+-------------------------------------------------------------+
|                     FLUTTER MOBILE APP                      |
|       (UI Components, Riverpod/BLoC, Local Storage, Cache)  |
+------------------------------+------------------------------+
                               | HTTPS / WSS (REST & Realtime)
                               v
+-------------------------------------------------------------+
|                   FASTAPI BACKEND SERVICE                   |
|  - Auth Middleware (Supabase JWT Verification)              |
|  - Intent Parsing & Prompt Orchestration Engine             |
|  - Function Calling Dispatcher & Validation                 |
|  - Background Worker / Cron Tasks (Celery / APScheduler)    |
+--------------------+--------------------+-------------------+
                     |                    |
        API Requests |                    | SQL Queries & pgvector
                     v                    v
       +-----------------------+  +-------------------------------+
       |   GOOGLE GEMINI API   |  |     SUPABASE POSTGRESQL       |
       |  - Gemini Flash/Pro   |  |  - Auth & User Profiles       |
       |  - Structured Tools   |  |  - Tasks, Events, Reminders   |
       |  - Embeddings (text)  |  |  - Notes with Vector Embed    |
       |                       |  |  - Row Level Security (RLS)   |
       +-----------------------+  |  - Supabase Storage (Audio/Img|
                                  +---------------+---------------+
                                                  |
                                                  v
                                  +-------------------------------+
                                  |   PUSH NOTIFICATION ENGINE    |
                                  |    (FCM / Supabase Edge Cron) |
                                  +-------------------------------+
```

### 4.2. Rincian Komponen Teknologi
1. **Frontend (Flutter):**
   - Clean Architecture (Data, Domain, Presentation).
   - Dynamic Chat UI dengan interactive action cards (misal: widget preview tugas yang baru dibuat dengan tombol "Edit" / "Batalkan").
   - Offline-first cache menggunakan SQLite/Isar untuk akses kalender & tugas tanpa koneksi.
2. **Backend (FastAPI):**
   - Asynchronous I/O (`asyncio`) untuk streaming respon AI.
   - Validasi data ketat menggunakan Pydantic v2.
   - Modul Function Calling Handler yang mengeksekusi *tools* langsung ke Supabase dengan kredensial aman.
3. **Database & Storage (Supabase):**
   - Supabase PostgreSQL dengan ekstensi `pgvector` untuk *Semantic RAG* pada catatan.
   - Row Level Security (RLS) menjamin privasi data antar pengguna secara mutlak di tingkat database.
   - Supabase Realtime untuk sinkronisasi instan status task antar perangkat.
4. **AI Core (Google Gemini API):**
   - Model: `gemini-1.5-flash` / `gemini-2.0-flash` untuk respon cepat (< 1 detik).
   - Structured Tool Calling: AI mendefinisikan JSON argument yang valid sesuai skema OpenAPI yang dikirimkan.
   - Text Embeddings: `text-embedding-004` untuk menyimpan dan mencari catatan pengguna.

---

## 5. Functional Requirements (Modul Fitur Utama)

### Modul 1: AI Conversational Agent & Action Execution
- **1.1 Multi-Turn Chat & Context Retention:** Asisten mengingat percakapan sebelumnya dalam satu sesi (minimal 10 pesan terakhir).
- **1.2 Compound Tool Calling (Multi-Action):** Mampu mengeksekusi lebih dari satu fungsi dalam satu instruksi pengguna.
- **1.3 Human-in-the-Loop Confirmation:** Untuk tindakan destruktif (hapus catatan, batalkan jadwal penting), AI meminta konfirmasi eksplisit pengguna sebelum eksekusi.
- **1.4 Streaming Response:** Respon teks AI di-stream secara bertahap via WebSocket/SSE demi UX yang responsif.
- **1.5 Action Previews:** Setiap kali AI mengeksekusi fungsi, aplikasi memunculkan Card interaktif di dalam bubble chat.

### Modul 2: Smart Task Management (To-Do & Action Items)
- **2.1 Task Data Model:** Judul, deskripsi, prioritas (`low`, `medium`, `high`, `urgent`), deadline (`due_date`), status (`pending`, `in_progress`, `completed`, `cancelled`), kategori/label.
- **2.2 Auto-Extraction:** AI otomatis mendeteksi prioritas dan waktu dari bahasa alami (contoh: *"kerjakan secepatnya"* -> priority `urgent`).
- **2.3 Sub-tasks & Checklist:** Kemampuan memecah tugas kompleks menjadi sub-tasks.
- **2.4 Filter & View:** Tampilan berbasis List, Kanban Board mini, dan Kalender Deadline.

### Modul 3: Calendar & Event Scheduling
- **3.1 Event Properties:** Judul event, waktu mulai, waktu selesai, lokasi (opsional/link virtual), peserta (opsional), deskripsi.
- **3.2 Conflict Detection:** Backend otomatis memvalidasi apakah ada jadwal bertabrakan sebelum memasukkan event baru dan memberi peringatan ke AI: *"Pengguna sudah memiliki jadwal lain pada jam tersebut, apakah ingin tetap ditambahkan?"*.
- **3.3 Recurring Events:** Dukungan event berulang (harian, mingguan, bulanan).
- **3.4 External Sync (Phase 2):** Sinkronisasi dua arah dengan Google Calendar dan Apple Calendar via CalDAV / Google API.

### Modul 4: Intelligent Reminders & Proactive Notifications
- **4.1 Flexible Trigger:**
  - *Time-based:* Jam dan tanggal spesifik (contoh: "10 menit sebelum rapat").
  - *Contextual/Relative:* Pengingat yang dikaitkan dengan deadline tugas.
- **4.2 Push Notification Delivery:** Integrasi FCM dengan *high-priority notification channels* agar alarm tetap berbunyi saat layar mati.
- **4.3 Snooze & Quick Actions:** Notifikasi memiliki tombol aksi instan: *"Snooze 10 Menit"*, *"Tandai Selesai"*.

### Modul 5: Second Brain & Knowledge Notes (Semantic Search)
- **5.1 Rich Notes:** Menyimpan catatan teks biasa, markdown, daftar poin, dan tautan.
- **5.2 Auto-Categorization & Tagging:** AI otomatis memberi saran tag/kategori yang relevan saat catatan disimpan.
- **5.3 Vector Semantic Search (pgvector):** Pengguna bisa mencari informasi secara konseptual. Misal mencari: *"resep masakan daging"* akan memunculkan catatan berjudul *"Bumbu Rendang Nenek"* meskipun kata "resep masakan daging" tidak muncul secara literal.

### Modul 6: Daily Briefing & Proactive Insights
- **6.1 Morning Digest (Pukul 07:00 default):**
  - Notifikasi ringkasan: *"Selamat pagi! Hari ini kamu punya 3 agenda penting dan 5 tugas yang harus diselesaikan."*
  - Kartu khusus di dashboard aplikasi yang merangkum cuaca, agenda pertama, dan tugas prioritas tinggi.
- **6.2 Evening Review (Pukul 20:00 default):**
  - Evaluasi capaian harian: tugas apa yang belum selesai dan opsi menjadwalkannya ke esok hari.

### Modul 7: Voice Input & Multi-Modal Processing
- **7.1 Speech-to-Text (STT):** Pengguna dapat menekan tombol mic untuk berbicara langsung.
- **7.2 Audio Note Parsing:** Pengguna dapat mengunggah rekaman suara rapat singkat; Gemini mengekstrak rangkuman dan poin tugas (*action items*).
- **7.3 Image/Document OCR:** Mengambil foto struk, tiket jadwal, atau tulisan papan tulis; AI mengekstrak jadwal dan tugas ke aplikasi.

---

## 6. AI Agent Tool Calling (Gemini Functions Schema)

FastAPI mendefinisikan tools berikut ke Gemini API:

### 6.1 `create_task`
```json
{
  "name": "create_task",
  "description": "Menambahkan tugas baru ke dalam daftar to-do pengguna.",
  "parameters": {
    "type": "OBJECT",
    "properties": {
      "title": { "type": "STRING", "description": "Judul atau nama tugas." },
      "description": { "type": "STRING", "description": "Detail deskripsi tugas (opsional)." },
      "due_date": { "type": "STRING", "description": "Waktu tenggat dalam format ISO-8601 (YYYY-MM-DDTHH:mm:ssZ)." },
      "priority": { "type": "STRING", "enum": ["low", "medium", "high", "urgent"] },
      "tags": { "type": "ARRAY", "items": { "type": "STRING" } }
    },
    "required": ["title"]
  }
}
```

### 6.2 `create_calendar_event`
```json
{
  "name": "create_calendar_event",
  "description": "Menjadwalkan agenda baru ke kalender pengguna.",
  "parameters": {
    "type": "OBJECT",
    "properties": {
      "title": { "type": "STRING", "description": "Nama kegiatan atau rapat." },
      "start_time": { "type": "STRING", "description": "Waktu mulai format ISO-8601." },
      "end_time": { "type": "STRING", "description": "Waktu selesai format ISO-8601." },
      "location": { "type": "STRING", "description": "Lokasi fisik atau link pertemuan virtual." },
      "is_all_day": { "type": "BOOLEAN" }
    },
    "required": ["title", "start_time", "end_time"]
  }
}
```

### 6.3 `set_reminder`
```json
{
  "name": "set_reminder",
  "description": "Mengatur pengingat spesifik pada waktu tertentu.",
  "parameters": {
    "type": "OBJECT",
    "properties": {
      "title": { "type": "STRING", "description": "Pesan pengingat." },
      "remind_at": { "type": "STRING", "description": "Waktu pengingat dibunyikan dalam format ISO-8601." },
      "reference_type": { "type": "STRING", "enum": ["task", "event", "general"] },
      "reference_id": { "type": "STRING", "description": "ID relasi jika merujuk task/event tertentu." }
    },
    "required": ["title", "remind_at"]
  }
}
```

### 6.4 `manage_notes`
```json
{
  "name": "manage_notes",
  "description": "Menyimpan atau mencari catatan pengguna menggunakan kata kunci atau pencarian semantik.",
  "parameters": {
    "type": "OBJECT",
    "properties": {
      "action": { "type": "STRING", "enum": ["create", "search", "update", "delete"] },
      "title": { "type": "STRING" },
      "content": { "type": "STRING" },
      "query": { "type": "STRING", "description": "Kata kunci pencarian untuk action 'search'." },
      "tags": { "type": "ARRAY", "items": { "type": "STRING" } }
    },
    "required": ["action"]
  }
}
```

---

## 7. Database Schema & Data Modeling (Supabase PostgreSQL)

Berikut adalah skema relasional tabel inti dengan integrasi RLS (Row Level Security):

### 7.1 Entity Relationship Overview
```
+------------------+       1:N       +------------------+
|   auth.users     | +-------------> |      tasks       |
+------------------+                 +------------------+
         |
         | 1:N                       +------------------+
         +-------------------------> | calendar_events  |
         |                           +------------------+
         | 1:N
         +-------------------------> |    reminders     |
         |                           +------------------+
         | 1:N
         +-------------------------> |      notes       | (pgvector enabled)
         |                           +------------------+
         | 1:N
         +-------------------------> |  chat_messages   |
```

### 7.2 Struktur Tabel Detail (DDL Reference)

```sql
-- Mengaktifkan ekstensi vector untuk RAG / Semantic Search
CREATE EXTENSION IF NOT EXISTS vector;

-- 1. Tasks Table
CREATE TABLE public.tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    priority TEXT CHECK (priority IN ('low', 'medium', 'high', 'urgent')) DEFAULT 'medium',
    status TEXT CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled')) DEFAULT 'pending',
    due_date TIMESTAMPTZ,
    tags TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Calendar Events Table
CREATE TABLE public.calendar_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    location TEXT,
    is_all_day BOOLEAN DEFAULT FALSE,
    recurrence_rule TEXT, -- format RFC 5545 iCalendar (opsional)
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Reminders Table
CREATE TABLE public.reminders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    remind_at TIMESTAMPTZ NOT NULL,
    is_sent BOOLEAN DEFAULT FALSE,
    reference_type TEXT CHECK (reference_type IN ('task', 'event', 'general')) DEFAULT 'general',
    reference_id UUID,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Notes Table dengan Semantic Vector
CREATE TABLE public.notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    tags TEXT[] DEFAULT '{}',
    embedding vector(768), -- Embedding vector dari Google text-embedding-004 (768 dimensi)
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Chat History Table
CREATE TABLE public.chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT CHECK (role IN ('user', 'assistant', 'system', 'tool')) NOT NULL,
    content TEXT NOT NULL,
    tool_calls JSONB,
    tool_results JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indeks untuk efisiensi kueri
CREATE INDEX idx_tasks_user_status ON public.tasks(user_id, status);
CREATE INDEX idx_events_user_time ON public.calendar_events(user_id, start_time);
CREATE INDEX idx_reminders_trigger ON public.reminders(remind_at, is_sent);
CREATE INDEX idx_notes_embedding ON public.notes USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

-- Row Level Security (RLS) Policies
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.calendar_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reminders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can only access their own tasks" ON public.tasks FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can only access their own events" ON public.calendar_events FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can only access their own reminders" ON public.reminders FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can only access their own notes" ON public.notes FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can only access their own chat messages" ON public.chat_messages FOR ALL USING (auth.uid() = user_id);
```

---

## 8. Non-Functional Requirements (NFR)

### 8.1. Performance & Latency
- **AI Streaming Latency:** Karakter pertama respons percakapan (TTFT - Time To First Token) harus muncul di UI Flutter dalam waktu `< 800 ms`.
- **Database Query Latency:** Eksekusi CRUD pada Supabase harus selesai dalam `< 100 ms` untuk 95% request (P95).
- **Cold Start App:** Waktu pembukaan aplikasi Flutter hingga siap menerima input pengguna `< 2 detik`.

### 8.2. Security, Privacy & Compliance
- **Zero Data Leakage:** Menggunakan Supabase Row Level Security (RLS) ketat sehingga tidak ada celah data pengguna tertukar.
- **Credential Storage:** Token JWT dan kredensial sensitif disimpan menggunakan `flutter_secure_storage` (Android Keystore & iOS Keychain).
- **Enkripsi Transit & Rest:** Seluruh komunikasi API wajib menggunakan HTTPS / TLS 1.3, dan data at-rest dienkripsi oleh Supabase.
- **Privacy Policy:** Riwayat percakapan tidak digunakan untuk fine-tuning model publik tanpa persetujuan eksplisit pengguna.

### 8.3. Reliability & Offline Resilience
- **Offline Cache:** Pengguna tetap dapat melihat daftar to-do dan kalender yang sudah di-cache saat offline.
- **Sync Queue:** Jika pengguna menandai tugas selesai saat offline, aksi disimpan di queue lokal dan otomatis disinkronkan saat koneksi internet kembali aktif.

---

## 9. Product Roadmap & Phased Implementation

```
+-----------------------------------------------------------------------------------+
| ROADMAP ALEXA                                                                     |
+-----------------------------------------------------------------------------------+
| PHASE 1: CORE MVP (Minggu 1 - 4)                                                  |
| - Supabase Setup (Auth, Tables, RLS)                                              |
| - FastAPI backend dengan Gemini Tool Calling (Task, Calendar, Basic Notes)        |
| - Flutter App: Auth UI, Chat Interface with Action Cards, Basic Task & Calendar   |
| - Local & Push Notification dasar                                                 |
+-----------------------------------------------------------------------------------+
                                         |
                                         v
+-----------------------------------------------------------------------------------+
| PHASE 2: ADVANCED INTELLIGENCE & SYNC (Minggu 5 - 8)                              |
| - Semantic Search di Notes menggunakan pgvector                                   |
| - Morning Briefing & Proactive Reminders                                          |
| - Speech-to-Text (Voice input via mic) & Audio Recording parsing                 |
| - Google Calendar 2-Way Sync Integration                                          |
+-----------------------------------------------------------------------------------+
                                         |
                                         v
+-----------------------------------------------------------------------------------+
| PHASE 3: MULTI-MODAL & EXPANSION (Minggu 9 - 12)                                  |
| - Image / OCR Processing (Scan struk, tiket, jadwal manual via kamera)            |
| - Smart Habit Tracking & Weekly Productivity Analytics Dashboard                 |
| - Widget iOS (Callout/Lockscreen) & Android Home Widgets                          |
| - Desktop & Web Version (Flutter Web / Desktop)                                   |
+-----------------------------------------------------------------------------------+
```

---

## 10. Edge Cases & Mitigation Strategies

| Skenario Kasus Batas (Edge Case) | Risiko | Strategi Mitigasi Sistem |
| :--- | :--- | :--- |
| **Instruksi Waktu Ambigu**<br>*(contoh: "Besok rapat jam 9")* | Salah menentukan AM vs PM (pagi vs malam). | AI prompt dikonfigurasi untuk mengasumsikan jam kerja (09:00 AM), namun bubble konfirmasi memunculkan pill: *"Apakah 09:00 pagi atau malam?"*. |
| **Konflik Jadwal Ganda**<br>*(menambah event di jam yang sudah terisi)* | Tabrakan agenda penting. | Backend memeriksa bentang waktu di database; jika overlap, FastAPI mengembalikan status `conflict_detected` agar AI menanyakan persetujuan user. |
| **Perintah Bersifat Merusak**<br>*(contoh: "Hapus semua tugasku")* | Kehilangan data tidak sengaja. | Wajibkan dialog konfirmasi manual di sisi UI Flutter sebelum aksi `delete_all` dijalankan. |
| **Koneksi Internet Putus Saat Chat AI** | Pesan gagal terkirim / status menggantung. | Retry mechanism otomatis dengan pesan status jelas di UI chat dan opsi simpan draft pesan. |
| **Rate Limit Gemini API** | Gagal merespon instruksi. | Implementasi exponential backoff di FastAPI dan fallback response caching yang ramah pengguna. |
