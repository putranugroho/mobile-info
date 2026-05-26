import 'package:flutter/material.dart';
import 'package:mobile_info/module/chat/chat_notifier.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  final String noRekening;
  final String namaProduk;

  const ChatPage({
    super.key,
    required this.noRekening,
    required this.namaProduk,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatNotifier(
        context: context,
        noRekening: noRekening,
        namaProduk: namaProduk,
      ),
      child: Consumer<ChatNotifier>(
        builder: (context, notifier, _) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: colorPrimary,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Bantuan Rekening",
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            actions: [
              if (!notifier.isLoading)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: notifier.isConnected
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        notifier.isConnected
                            ? "Online"
                            : "Menghubungkan...",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          body: notifier.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _RekeningCard(
                        noRekening: noRekening, namaProduk: namaProduk),
                    const Divider(height: 1),
                    Expanded(child: _ChatList(notifier: notifier)),
                    _InputBar(notifier: notifier),
                  ],
                ),
        ),
      ),
    );
  }
}

class _RekeningCard extends StatelessWidget {
  final String noRekening;
  final String namaProduk;

  const _RekeningCard(
      {required this.noRekening, required this.namaProduk});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance, color: colorPrimary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaProduk,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  noRekening,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  final ChatNotifier notifier;
  const _ChatList({required this.notifier});

  @override
  Widget build(BuildContext context) {
    final messages = notifier.messages;

    if (messages.isEmpty) {
      return const Center(
        child: Text("Belum ada pesan",
            style: TextStyle(color: Colors.grey, fontSize: 13)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      controller: notifier.scrollController,
      itemCount: messages.length,
      itemBuilder: (_, i) {
        final msg = messages[i];
        final from = msg["from"] as String;
        final isUser = from == "user";
        final isSystem = from == "system";

        if (isSystem) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  msg["message"] as String,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          );
        }

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            decoration: BoxDecoration(
              color: isUser ? colorPrimary : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
            ),
            child: Text(
              msg["message"] as String,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InputBar extends StatefulWidget {
  final ChatNotifier notifier;
  const _InputBar({required this.notifier});

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.notifier.send(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: "Tulis pesan...",
                  hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide:
                        const BorderSide(color: colorPrimary),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _send,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: colorPrimary,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
