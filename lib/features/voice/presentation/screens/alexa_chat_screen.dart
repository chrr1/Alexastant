import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../screens/voice_conversation_screen.dart';
import '../../../chat/presentation/widgets/action_confirmation_card.dart';
import '../../../chat/presentation/widgets/chat_input_bar.dart';

class ChatMessageModel {
  final String text;
  final bool isUser;
  final String time;
  final bool hasActionCard;

  ChatMessageModel({
    required this.text,
    required this.isUser,
    required this.time,
    this.hasActionCard = false,
  });
}

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

    // Mock AI Response
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
            _buildHeader(),
            _buildQuickVoiceBanner(),
            Expanded(child: _buildChatList()),
            _buildSuggestedPrompts(),
            _buildBottomInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.orangeGradient,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alexa AI Assistant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: AppColors.success),
                      SizedBox(width: 5),
                      Text(
                        'Online · Siap Membantu',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Voice Mode Direct Shortcut
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const VoiceConversationScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryOrangeSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryOrange.withOpacity(0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.mic_rounded,
                    color: AppColors.primaryOrangeLight,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Voice Mode',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryOrangeLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickVoiceBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const VoiceConversationScreen(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: AppColors.orangeGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: AppColors.primaryOrangeGlow,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.record_voice_over_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bicara Langsung dengan Alexa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Ketuk untuk membuka mode visualizer suara',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return _buildMessageItem(msg);
      },
    );
  }

  Widget _buildMessageItem(ChatMessageModel msg) {
    if (msg.isUser) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 4),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(4),
              ),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Text(
              msg.text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFE5E7EB),
                height: 1.45,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 8),
            child: Text(
              msg.time,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Action Execution Card from user's reference
          if (msg.hasActionCard)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ActionConfirmationCard(
                title: 'Meeting with Team',
                dateSubtitle: 'Monday, 09 September 2024',
                description:
                    "I hope this email finds you well! It's been a while since we last caught up, and I wanted to check in and see how you're doing..",
                onCancel: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Jadwal rapat dibatalkan.'),
                      backgroundColor: AppColors.surfaceSecondary,
                    ),
                  );
                },
                onConfirm: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Jadwal dan pengingat rapat berhasil dibuat ke kalender!',
                      ),
                      backgroundColor: AppColors.primaryOrange,
                    ),
                  );
                },
              ),
            ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 4),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Text(
              msg.text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              msg.time,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildSuggestedPrompts() {
    return Container(
      height: 36,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _suggestedPrompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final prompt = _suggestedPrompts[index];
          return GestureDetector(
            onTap: () => _sendMessage(prompt),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.subdirectory_arrow_right_rounded,
                    size: 13,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    prompt,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
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
    );
  }
}

