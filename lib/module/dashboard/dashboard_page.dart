// import 'package:flutter/material.dart';
// import 'package:mobile_info/module/dashboard/dashboard_notifier.dart';
// import 'package:mobile_info/utils/pro_shimmer.dart';
// import 'package:provider/provider.dart';

// class DashboardPage extends StatelessWidget {
//   const DashboardPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => DashboardNotifier(context: context),
//       child: Consumer<DashboardNotifier>(
//         builder: (context, value, child) => SafeArea(
//           child: Scaffold(
//             backgroundColor: Colors.grey[200],
//             body: Center(
//               child: Container(
//                 width: MediaQuery.of(context).size.width > 600
//                     ? 400
//                     : MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(color: Colors.white),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Container(
//                       height: 60,
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       alignment: Alignment.centerLeft,
//                       decoration: BoxDecoration(
//                         border: Border(
//                           bottom: BorderSide(
//                             width: 1,
//                             color: Colors.grey[200]!,
//                           ),
//                         ),
//                       ),
//                       child: Text(
//                         "Bank Account BPR",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView(
//                         children: [
//                           value.isLoading
//                               ? Container(
//                                   padding: const EdgeInsets.all(16),
//                                   child: const Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       ProShimmer(height: 10, width: 200),
//                                       SizedBox(height: 4),
//                                       ProShimmer(height: 10, width: 120),
//                                       SizedBox(height: 4),
//                                       ProShimmer(height: 10, width: 100),
//                                       SizedBox(height: 4),
//                                     ],
//                                   ),
//                                 )
//                               : Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                     ListView.builder(
//                                       padding: EdgeInsets.all(20),
//                                       itemCount: value.list.length,
//                                       shrinkWrap: true,
//                                       physics: ClampingScrollPhysics(),
//                                       itemBuilder: (context, i) {
//                                         final data = value.list[i];
//                                         return Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.stretch,
//                                           children: [
//                                             InkWell(
//                                               onTap: () {
//                                                 value.pilihAkun(data);
//                                               },
//                                               child: Card(
//                                                 elevation: 10,
//                                                 color: Colors.white,
//                                                 child: Container(
//                                                   padding: EdgeInsets.all(12),
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           8,
//                                                         ),
//                                                   ),
//                                                   child: Row(
//                                                     children: [
//                                                       Expanded(
//                                                         child: Column(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .stretch,
//                                                           children: [
//                                                             Text(
//                                                               "${data.bprNama}",
//                                                               style: TextStyle(
//                                                                 fontSize: 12,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               "${data.noRekening}",
//                                                               style: TextStyle(
//                                                                 fontSize: 12,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w300,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       SizedBox(width: 16),
//                                                       Image.network(
//                                                         "https://infoservices.medtrans.id/webServices/image-proxy.php?url=${data.bprLogo}",
//                                                         height: 50,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(height: 16),
//                                           ],
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
