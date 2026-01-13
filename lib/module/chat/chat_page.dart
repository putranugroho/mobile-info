import 'package:flutter/material.dart';
import 'package:mobile_info/module/chat/chat_notifier.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatNotifier(context: context),
      child: Consumer(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white),
                width: MediaQuery.of(context).size.width > 600 ? 400 : MediaQuery.of(context).size.width,
                child: _ChatBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatBody extends StatefulWidget {
  const _ChatBody();

  @override
  State<_ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<_ChatBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ChatNotifier>();

    // if (!notifier.isOpened) {
    //   return _OpenSupport(notifier: notifier);
    // }

    return notifier.isLoading
        ? Center(child: const CircularProgressIndicator())
        : Column(
            children: [
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))],
                ),
              ),
              Expanded(child: _ChatList()),
              _InputBar(
                controller: _controller,
                onSend: () {
                  notifier.send(_controller.text);
                  _controller.clear();
                },
              ),
            ],
          );
  }
}

class _ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messages = context.watch<ChatNotifier>().messages;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      controller: context.watch<ChatNotifier>().scrollController,
      itemCount: messages.length,
      itemBuilder: (_, i) {
        final msg = messages[i];
        final isUser = msg["from"] == "user";

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 260),
            decoration: BoxDecoration(color: isUser ? Colors.blue : Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
            child: Text(msg["message"], style: TextStyle(color: isUser ? Colors.white : Colors.black)),
          ),
        );
      },
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: "Tulis pesan...", border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.send), onPressed: onSend),
          ],
        ),
      ),
    );
  }
}
