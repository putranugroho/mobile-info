import 'package:flutter/material.dart';
import 'package:mobile_info/module/bantuan/bantuan_notifier.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:provider/provider.dart';

class BantuanPage extends StatefulWidget {
  const BantuanPage({super.key});

  @override
  State<BantuanPage> createState() => _BantuanPageState();
}

class _BantuanPageState extends State<BantuanPage> {
  int _sessionKey = 0;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(_sessionKey),
      child: ChangeNotifierProvider(
        create: (ctx) => BantuanNotifier(context: ctx),
        child: Consumer<BantuanNotifier>(
          builder: (context, notifier, _) => SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.grey[200],
              body: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width > 600
                      ? 400
                      : MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    children: [
                      _AppBar(notifier: notifier),
                      const Divider(height: 1),
                      if (notifier.isLoading)
                        const Expanded(
                            child: Center(child: CircularProgressIndicator()))
                      else ...[
                        Expanded(child: _ChatList(notifier: notifier)),
                        notifier.isSessionClosed
                            ? _SessionClosedBar(
                                onNewSession: () =>
                                    setState(() => _sessionKey++),
                              )
                            : _InputBar(notifier: notifier),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final BantuanNotifier notifier;
  const _AppBar({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: colorPrimary,
      child: Row(
        children: [
          const Text(
            "Bantuan / CS",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          if (!notifier.isLoading)
            Row(
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
                  notifier.isConnected ? "Online" : "Menghubungkan...",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  final BantuanNotifier notifier;
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
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          );
        }

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

class _SessionClosedBar extends StatelessWidget {
  final VoidCallback onNewSession;
  const _SessionClosedBar({required this.onNewSession});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Sesi chat telah berakhir",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNewSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text("Mulai Chat Baru"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatefulWidget {
  final BantuanNotifier notifier;
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
                    borderSide: const BorderSide(color: colorPrimary),
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
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
