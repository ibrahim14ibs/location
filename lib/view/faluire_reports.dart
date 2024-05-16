import 'package:flutter/material.dart';

import '../core/helper/database_helper.dart';

class FaluireReports extends StatefulWidget {
  const FaluireReports({super.key});

  @override
  State<FaluireReports> createState() => _FaluireReportsState();
}

class _FaluireReportsState extends State<FaluireReports> {
  final databaseHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FaluireReports'),
        ),
        body: FutureBuilder(
          future: databaseHelper.queryAllRows('faluire_info_v1'),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data?.isEmpty ?? true) {
                return const Center(
                  child: Text('no data'),
                );
              }
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(snapshot.data![index]['date'].toString()),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Text('ERROR'),
                            Text(snapshot.data![index]['error'].toString())
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: snapshot.data?.length ?? 0);
              //  ScrollableTableView(
              //   columns: const [
              //     TableViewColumn(label: "DATE"),
              //     TableViewColumn(label: "LATITUDE"),
              //     TableViewColumn(label: "LANGITUDE"),
              //     TableViewColumn(label: "GPS ENABLED"),
              //     TableViewColumn(label: "PERMISSION"),
              //     TableViewColumn(label: "IS INTERNET ACTIVE"),
              //   ],
              //   rows: locationInfo
              //       .map((info) => TableViewRow(cells: [
              //             TableViewCell(
              //               child: Text(info.date),
              //             ),
              //             TableViewCell(child: Text(info.latitude.toString())),
              //             TableViewCell(child: Text(info.longitude.toString())),
              //             TableViewCell(
              //                 child: Text(info.serviceEnabled.toString())),
              //             TableViewCell(child: Text(info.permission.name)),
              //             TableViewCell(
              //                 child: Text(info.isInternetActive.toString())),
              //           ]))
              //       .toList(),
              // );
            }
          },
        ));
  }
}
