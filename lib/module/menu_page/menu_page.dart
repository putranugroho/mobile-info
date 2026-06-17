import 'package:flutter/material.dart';
import 'package:mobile_info/module/home/home_page.dart';
import 'package:mobile_info/module/menu_page/menu_notifier.dart';
import 'package:mobile_info/module/profile/profile_page.dart';
import 'package:mobile_info/module/bantuan/bantuan_page.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuNotifier(context: context),
      child: Consumer<MenuNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width > 600
                    ? 400
                    : MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.white),
                child: PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (_, result) => value.back(),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 64,
                        child: value.page == 0
                            ? const HomePage()
                            : value.page == 1
                                ? const BantuanPage()
                                : const ProfilePage(),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _BottomNav(
                          current: value.page,
                          onTap: value.gantiPage,
                        ),
                      ),
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

class _BottomNav extends StatelessWidget {
  final int current;
  final void Function(int) onTap;

  const _BottomNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          _NavItem(index: 0, current: current, icon: Icons.home_outlined, activeIcon: Icons.home, label: "Home", onTap: onTap),
          _NavItem(index: 1, current: current, icon: Icons.help_outline, activeIcon: Icons.help, label: "Bantuan", onTap: onTap),
          _NavItem(index: 3, current: current, icon: Icons.person_outline, activeIcon: Icons.person, label: "Profil", onTap: onTap),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int current;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final void Function(int) onTap;

  const _NavItem({
    required this.index,
    required this.current,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = current == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: colorPrimary.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? colorPrimary.withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 22,
                color: isSelected ? colorPrimary : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? colorPrimary : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
