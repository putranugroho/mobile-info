import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/bank_model.dart';
import '../../utils/button_custom.dart';
import 'add_bank_notifier.dart';

class AddBankPage extends StatelessWidget {
  final BankModel bankModel;
  const AddBankPage({super.key, required this.bankModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddBankNotifier(context, bankModel),
      child: Consumer<AddBankNotifier>(
        builder: (context, value, child) => SafeArea(
            child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[300]),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      "${bankModel.name}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: value.keyForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Add a new bank account",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Account Number",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          TextField(
                            controller: value.account,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "Enter bank account number"),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ButtonPrimary(
                            onTap: () {
                              value.cek();
                            },
                            name: "Verify",
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        )),
      ),
    );
  }
}
