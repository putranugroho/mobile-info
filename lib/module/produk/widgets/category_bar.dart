import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../produk_enum.dart';
import '../produk_notifier.dart';
import '../../../utils/colors.dart';

class CategoryBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProdukNotifier>(
      builder: (context, notifier, _) => Container(
        height: 60,
        color: Colors.white,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: ProdukKategori.values.map((kategori) {
            final isActive = notifier.activeKategori == kategori;

            return GestureDetector(
              onTap: () => notifier.scrollTo(kategori),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isActive ? colorPrimary.withOpacity(0.1) : Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kategori.label,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isActive ? colorPrimary : Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 3,
                      width: isActive ? 18 : 0,
                      decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(2)),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
