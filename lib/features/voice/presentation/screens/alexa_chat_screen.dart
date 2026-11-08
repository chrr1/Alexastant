import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';
import 'package:alexa/features/voice/domain/models/chat_message_model.dart';
import 'package:alexa/features/voice/presentation/screens/voice_conversation_screen.dart';
import 'package:alexa/features/voice/presentation/widgets/chat_top_bar.dart';
import 'package:alexa/features/voice/presentation/widgets/quick_voice_banner.dart';
import 'package:alexa/features/voice/presentation/widgets/chat_message_bubble.dart';
import 'package:alexa/features/voice/presentation/widgets/suggested_prompts_bar.dart';
import 'package:alexa/features/chat/presentation/widgets/chat_input_bar.dart';

// Re-export model agar tidak ada breaking change pada file lain
export 'package:alexa/features/voice/domain/models/chat_message_model.dart';

class AlexaChatScreen extends StatefulWidget {
  const AlexaChatScreen({super.key});

  @override
  State<AlexaChatScreen> createState() => _AlexaChatScreenState();
}

class _AlexaChatScreenState extends State<AlexaChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessageModel> _messages = [
    ChatMessageModel(
      text:
          'Halo Peter! Aku Alexa, asisten pribadimu. Ada yang bisa aku bantu untuk jadwal, tugas, atau catatan hari ini?',
      isUser: false,
      time: '11:42',
    ),
    ChatMessageModel(
      text:
          'Remind me to hold an online meeting with my work team using Zoom at 1 pm to discuss annual employee recruitment, and use the zoom.com link',
      isUser: true,
      time: '11:45',
      hasActionCard: true,
    ),
  ];

  final List<String> _suggestedPrompts = [
    'Buatkan tugas belajar FastAPI',
    'Jadwalkan meeting besok jam 10',
    'Apa jadwalku hari ini?',
    'Simpan catatan arsitektur sistem',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessageModel(
          text: text,
          isUser: true,
          time: 'Sekarang',
        ),
      );
      _textController.clear();
    });

    // Mock AI response setelah 700ms
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessageModel(
            text: 'Permintaan kamu sedang diproses oleh Alexa: "$text"',
            isUser: false,
            time: 'Sekarang',
          ),
        );
      });
      _scrollToBottom();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: identitas Alexa + shortcut Voice Mode
            const ChatTopBar(),

            // Banner CTA beralih ke mode suara
            const QuickVoiceBanner(),

            // Daftar pesan chat
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatMessageBubble(
                    message: _messages[index],
                    parentContext: context,
                  );
                },
              ),
            ),

            // Chip saran prompt horizontal
            SuggestedPromptsBar(
              prompts: _suggestedPrompts,
              onPromptTap: _sendMessage,
            ),

            // Input bar + tombol kirim / mic / lampiran
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
              child: ChatInputBar(
                controller: _textController,
                onSend: () => _sendMessage(_textController.text),
                onMicTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const VoiceConversationScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
