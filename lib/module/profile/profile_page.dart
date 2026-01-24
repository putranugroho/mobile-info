import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_info/module/profile/ganti_mpin/ganti_mpin_page.dart';
import 'package:mobile_info/module/profile/profile_notifier.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../network/network.dart';
import '../../utils/pro_shimmer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileNotiifer(context: context),
      child: Consumer<ProfileNotiifer>(
        builder: (context, value, child) => Scaffold(
          body: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Profil",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        // InkWell(
                        //   onTap: () => value.ambilCover(),
                        //   child: CachedNetworkImage(
                        //     placeholder: (context, url) =>
                        //         ProShimmer(height: 50, width: 50, radius: 360),
                        //     fit: BoxFit.cover,
                        //     imageBuilder: (context, imageProvider) => Container(
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(360),
                        //         border: Border.all(
                        //           width: 1,
                        //           color: Colors.grey,
                        //         ),
                        //         image: DecorationImage(
                        //           image: imageProvider,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ),
                        //     height: 50,
                        //     width: 50,
                        //     imageUrl:
                        //         "https://infoservices.medtrans.id/webServices/image-proxy.php?url=$photo/${value.users!.photo}",
                        //     errorWidget: (context, url, error) =>
                        //         const Icon(Icons.error),
                        //   ),
                        // ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "${value.users!.nama}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    value.hide
                                        ? "${value.users!.nomorPonsel.substring(0, 4)}xxxx${value.users!.nomorPonsel.substring(value.users!.nomorPonsel.length - 4, value.users!.nomorPonsel.length)}"
                                        : value.users!.nomorPonsel,
                                    style: TextStyle(),
                                  ),
                                  SizedBox(width: 12),
                                  InkWell(
                                    onTap: () {
                                      value.gantihide();
                                    },
                                    child: Icon(
                                      value.hide
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(
                        //       Icons.notifications,
                        //       color: colorSecondary,
                        //       size: 36,
                        //     ))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 2),
                      color: Colors.grey,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GantiMPINPage(),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.lock, size: 20),
                            SizedBox(width: 12),
                            Text("Ganti Password"),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 15),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () => value.confirm(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.exit_to_app, size: 20),
                            SizedBox(width: 12),
                            Text("Keluar"),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
