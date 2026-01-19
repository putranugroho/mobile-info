import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/verifikasi_ktp_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/pro_shimmer.dart';
import 'package:provider/provider.dart';

class VerifikasiKTPPage extends StatelessWidget {
  const VerifikasiKTPPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VerifikasiKTPNotifier(context: context),
      child: Consumer<VerifikasiKTPNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width > 600
                    ? 400
                    : MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.white),
                child: Form(
                  key: value.keyForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.grey[300] ?? Colors.transparent,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_ios, size: 20),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(20),
                          children: [
                            value.isLoading
                                ? Container(
                                    padding: const EdgeInsets.all(16),
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ProShimmer(height: 10, width: 200),
                                        SizedBox(height: 4),
                                        ProShimmer(height: 10, width: 120),
                                        SizedBox(height: 4),
                                        ProShimmer(height: 10, width: 100),
                                        SizedBox(height: 4),
                                      ],
                                    ),
                                  )
                                : value.ketmu
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Data Ditemukan",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Silahkan cek kembali data Anda",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "Nama Lengkap",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(height: 4),
                                      TextFormField(
                                        enabled: false,
                                        controller: value.namaLengkap,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "Nomor Ponsel",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(height: 4),
                                      TextFormField(
                                        enabled: false,
                                        controller: value.nomorPonsel,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "User ID",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(height: 4),
                                      TextFormField(controller: value.userId),
                                      SizedBox(height: 16),
                                      Text(
                                        "Kata Sandi",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(height: 4),
                                      TextFormField(
                                        obscureText: value.obSecure1,
                                        decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                            onTap: () => value.gantiObsecure1(),
                                            child: Icon(
                                              value.obSecure1 == true
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                          ),
                                        ),
                                        validator: (e) {
                                          if (!RegExp(
                                            ".*[0-9].*",
                                          ).hasMatch(e ?? '')) {
                                            return 'Harus ada angka, huruf kecil dan huruf besar';
                                          }
                                          if (!RegExp(
                                            '.*[a-z].*',
                                          ).hasMatch(e ?? '')) {
                                            return 'Harus ada angka, huruf kecil dan huruf besar';
                                          }
                                          if (!RegExp(
                                            '.*[A-Z].*',
                                          ).hasMatch(e ?? '')) {
                                            return 'Harus ada angka, huruf kecil dan huruf besar';
                                          }
                                          return null;
                                        },
                                        controller: value.kataSandi,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "Ulangi Kata Sandi",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(height: 4),
                                      TextFormField(
                                        obscureText: value.obSecure2,
                                        decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                            onTap: () => value.gantiObsecure2(),
                                            child: Icon(
                                              value.obSecure2 == true
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                          ),
                                        ),
                                        validator: (e) {
                                          if (e != value.kataSandi.text) {
                                            return "Konfirmasi Kata Sandi tidak tepat";
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: value.konfirmasiKataSandi,
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Verifikasi Akun Anda",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Lengkapi data dibawah ini",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "Pilih BPR",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(height: 4),
                                      DropdownButton(
                                        isExpanded: true,
                                        value: value.bprModel,
                                        items: value.list
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                  child: Text(
                                                    e.namaBpr,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (e) {
                                          value.gantiBpr(e!);
                                        },
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "No KTP",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(height: 4),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: value.noKtp,
                                        validator: (e) {
                                          if (e!.isEmpty) {
                                            return "Wajib diisi";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          hintText: "No KTP",
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "Nomor Ponsel",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(height: 4),
                                      TextFormField(
                                        keyboardType: TextInputType.phone,
                                        controller: value.nomorPonsel,
                                        validator: (e) {
                                          if (e!.isEmpty) {
                                            return "Wajib diisi";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          hintText: "08xxxx",
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: ButtonPrimary(
                          onTap: () {
                            value.ketmu ? value.pin() : value.cek();
                          },
                          name: value.ketmu
                              ? "Aktifkan User"
                              : "Verifikasi Akun",
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
