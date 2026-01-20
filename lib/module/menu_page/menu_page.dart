import 'package:flutter/material.dart';
import 'package:mobile_info/module/home/home_page.dart';
import 'package:mobile_info/module/menu_page/menu_notifier.dart';
import 'package:mobile_info/module/profile/profile_page.dart';
import 'package:mobile_info/module/riwayat/riwayat_page.dart';
import 'package:mobile_info/module/produk/produk_page.dart';
import 'package:mobile_info/module/video_call/video_call_screen.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/images_path.dart';
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
                child: WillPopScope(
                  onWillPop: value.back,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 60,
                        child: value.page == 0 ? HomePage() : ProfilePage(),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 1,
                                color: Colors.grey[300] ?? Colors.transparent,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () => value.gantiPage(0),
                                child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 5,
                                        right: 0,
                                        child: value.page == 0
                                            ? Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: colorPrimary,
                                                  shape: BoxShape.circle,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ),
                                      Positioned.fill(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              value.page == 0
                                                  ? ImageAssets.homeSelect
                                                  : ImageAssets.homeUnselect,
                                              height: 26,
                                              color: value.page == 0
                                                  ? colorTop
                                                  : Colors.grey,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Home",
                                              style: TextStyle(
                                                color: value.page == 0
                                                    ? colorPrimary
                                                    : Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// PROFIL
                              InkWell(
                                onTap: () => value.gantiPage(3),
                                child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 5,
                                        right: 0,
                                        child: value.page == 3
                                            ? Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: colorPrimary,
                                                  shape: BoxShape.circle,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ),
                                      Positioned.fill(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              value.page == 3
                                                  ? ImageAssets.userSelect
                                                  : ImageAssets.userUnselect,
                                              height: 26,
                                              color: value.page == 3
                                                  ? colorTop
                                                  : Colors.grey,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Profil",
                                              style: TextStyle(
                                                color: value.page == 3
                                                    ? colorPrimary
                                                    : Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
      ),
    );
  }
}
