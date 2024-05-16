import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:location_monitor/core/error/exception.dart';
import 'package:intl/intl.dart';

import '../model/location_info.dart';

class LocationHelper {
  static Future<LocationInfo> getPosition() async {
    bool isInternetActive = await InternetConnection().hasInternetAccess;
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      permission = await Geolocator.checkPermission();
      return LocationInfo(
          date: DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
          latitude: null,
          longitude: null,
          serviceEnabled: serviceEnabled,
          permission: permission,
          isInternetActive: isInternetActive,
          exception: const ServiceEnabledException());
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //permission = await Geolocator.requestPermission();
      // if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return LocationInfo(
          date: DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
          latitude: null,
          longitude: null,
          serviceEnabled: serviceEnabled,
          permission: permission,
          isInternetActive: isInternetActive,
          exception: const LocationPermissionDeniedException());
      // return Future.error('Location permissions are denied');
      // }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return LocationInfo(
          date: DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
          latitude: null,
          longitude: null,
          serviceEnabled: serviceEnabled,
          permission: permission,
          isInternetActive: isInternetActive,
          exception: const LocationPermissionPermanentlyDeniedException());
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return LocationInfo(
        date: DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        serviceEnabled: serviceEnabled,
        permission: permission,
        isInternetActive: isInternetActive,
        exception: const LocationPermissionPermanentlyDeniedException());
    // return await Geolocator.getCurrentPosition();
  }
}
