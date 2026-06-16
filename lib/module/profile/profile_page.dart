import 'package:flutter/material.dart';
import 'package:mobile_info/module/profile/edit_profile_page.dart';
import 'package:mobile_info/module/profile/ganti_mpin/ganti_mpin_page.dart';
import 'package:mobile_info/module/profile/profile_notifier.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileNotiifer(context: context),
      child: Consumer<ProfileNotiifer>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: colorBackground,
          body: ListView(
            children: [
              // ── Header merah dengan avatar ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colorPrimary, colorPrimaryDark],
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Profil",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(
                        value.users?.nama.isNotEmpty == true
                            ? value.users!.nama[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      value.users?.nama ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value.users != null
                              ? (value.hide
                                  ? "${value.users!.nomorPonsel.substring(0, 4)}xxxx${value.users!.nomorPonsel.substring(value.users!.nomorPonsel.length - 4)}"
                                  : value.users!.nomorPonsel)
                              : '',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => value.gantihide(),
                          child: Icon(
                            value.hide
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white.withValues(alpha: 0.85),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Menu card ──
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _menuItem(
                      icon: Icons.edit_outlined,
                      label: "Edit Profil",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfilePage()),
                      ).then((_) => value.getProfile()),
                    ),
                    _divider(),
                    _menuItem(
                      icon: Icons.lock_outline,
                      label: "Ganti Password",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GantiMPINPage()),
                      ),
                    ),
                    _divider(),
                    _menuItem(
                      icon: Icons.logout,
                      label: "Keluar",
                      onTap: () => value.confirm(),
                      isDestructive: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red.shade700 : Colors.black87;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.shade50
                    : colorPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isDestructive ? Colors.red.shade700 : colorPrimary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.only(left: 66),
        child: Divider(height: 1, color: Colors.grey.shade100),
      );
}
