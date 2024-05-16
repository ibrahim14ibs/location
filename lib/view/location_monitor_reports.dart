import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_monitor/core/error/exception.dart';
import 'package:location_monitor/core/helper/firebase_firestore_helper.dart';
import 'package:location_monitor/core/model/location_info.dart';
import 'package:location_monitor/view/faluire_reports.dart';

import '../core/helper/database_helper.dart';
import '../core/helper/location_helper.dart';

class LocationMonitorReports extends StatefulWidget {
  const LocationMonitorReports({super.key});

  @override
  State<LocationMonitorReports> createState() => _LocationMonitorReportsState();
}

class _LocationMonitorReportsState extends State<LocationMonitorReports>
    with WidgetsBindingObserver {
  final databaseHelper = DatabaseHelper.instance;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // _locationMonitor();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // _locationMonitor();
    }
  }

  Future<void> _locationMonitor() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      var locationInfo = await LocationHelper.getPosition();
      switch (locationInfo.exception) {
        case ServiceEnabledException():
          print('ServiceEnabledException');
          _requestUserToEnableGPS();
          break;
        case LocationPermissionDeniedException():
          print(LocationPermissionDeniedException);
          _requestUserToGrantLocationPermissionManually();
          break;
        case LocationPermissionPermanentlyDeniedException():
          print('LocationPermissionPermanentlyDeniedException');
          _requestUserToGrantLocationPermissionManually();
          break;
        default:
      }
      locationInfo.info();
      var id = await DatabaseHelper.instance
          .insert('location_info', locationInfo.toMap());
      print('id: $id');
       FirebaseFirestoreHelper.storeLocationInfo(
          locationInfo: locationInfo);
      print('success');
    } catch (e) {
      print('falure: $e');
    }
  }

  void _requestUserToEnableGPS() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable Location Services to continue.'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                // Open the location settings page
                Geolocator.openLocationSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _requestUserToGrantLocationPermissionManually() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permissions Denied'),
          content: Text(
              'Please enable location permissions manually in the app settings.'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                // Open the location settings page
                Geolocator.openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LocationMonitorReports'),
          leading: IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FaluireReports(),
                  )),
              icon: const Icon(Icons.bug_report)),
        ),
        body: FutureBuilder(
          future: databaseHelper.queryAllRows('location_info'),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<LocationInfo> locationInfo = snapshot.data
                      ?.map((map) => LocationInfo.fromMap(map))
                      .toList() ??
                  [];
              if (locationInfo.isEmpty) {
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
                          child: Text(locationInfo[index].date),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('LATITUDE'),
                            Text(locationInfo[index].latitude.toString())
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('LANGITUDE'),
                            Text(locationInfo[index].longitude.toString())
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('GPS ENABLED'),
                            Text(locationInfo[index].serviceEnabled.toString())
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('PERMISSION'),
                            Text(locationInfo[index].permission.name)
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('IS INTERNET ACTIVE'),
                            Text(
                                locationInfo[index].isInternetActive.toString())
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: locationInfo.length);
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
