import 'package:flutter/material.dart';

class ProdukSection extends StatelessWidget {
  final String title;
  final GlobalKey sectionKey;
  final List<Widget> children;

  const ProdukSection({super.key, required this.title, required this.sectionKey, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
