import 'package:flutter/material.dart';

import 'button_custom.dart';

class CustomDialog {
  static void loading(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.white,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: const Text("Sedang diproses..."),
          );
        });
  }

  static void messageResponse(BuildContext context, String text) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text),
                const SizedBox(
                  height: 16,
                ),
                ButtonPrimary(
                  onTap: () => Navigator.pop(context),
                  name: "Ok",
                )
              ],
            ),
          );
        });
  }

  static void messageDevelopment(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: const Text("API KEY GOOGLE SERVICE NOT MATCH"),
          );
        });
  }
}
