import 'package:flutter/material.dart';
import 'package:mobile_info/module/profile/edit_profile_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileNotifier(context: context),
      child: Consumer<EditProfileNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width > 600 ? 400 : MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1, color: Colors.grey[300] ?? Colors.transparent)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios, size: 20),
                          ),
                          const Text("Edit Profil", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Form(
                        key: value.keyForm,
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            const Text("Nama Lengkap", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: value.nama,
                              validator: (e) => (e == null || e.isEmpty) ? "Wajib diisi" : null,
                              decoration: InputDecoration(
                                hintText: "Nama lengkap",
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text("Nomor HP", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: value.noHp,
                              keyboardType: TextInputType.phone,
                              validator: (e) => (e == null || e.isEmpty) ? "Wajib diisi" : null,
                              decoration: InputDecoration(
                                hintText: "08xxxxxxxxxx",
                                prefixIcon: const Icon(Icons.phone_outlined),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text("Tanggal Lahir", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: value.tglLahir,
                              readOnly: true,
                              onTap: () => value.pilihTanggal(),
                              decoration: InputDecoration(
                                hintText: "YYYY-MM-DD",
                                prefixIcon: const Icon(Icons.calendar_today_outlined),
                                suffixIcon: const Icon(Icons.arrow_drop_down),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ButtonPrimary(
                              onTap: () => value.simpan(),
                              name: "Simpan Perubahan",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
