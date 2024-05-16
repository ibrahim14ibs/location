// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:geolocator/geolocator.dart';

class LocationInfo {
  final String date;
  final String? latitude;
  final String? longitude;
  final bool serviceEnabled;
  final LocationPermission permission;
  final bool isInternetActive;
  final Exception? exception;
  LocationInfo({
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.serviceEnabled,
    required this.permission,
    this.exception,
    required this.isInternetActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'latitude': latitude,
      'longitude': longitude,
      'serviceEnabled': serviceEnabled ? 1 : 0,
      'permission': permission.name,
      'isInternetActive': isInternetActive ? 1 : 0,
    };
  }

  factory LocationInfo.fromMap(Map<String, dynamic> map) {
    return LocationInfo(
      date: map['date'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      serviceEnabled: map['serviceEnabled'] == 1,
      permission: LocationPermission.values
          .where((element) => element.name == map['permission'])
          .first,
      isInternetActive: map['isInternetActive'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationInfo.fromJson(String source) =>
      LocationInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  info() {
    print('date:$date');
    print('latitude:$latitude');
    print('longitude:$longitude');
    print('serviceEnabled:$serviceEnabled');
    print('permission:$permission');
    print('isInternetActive:$isInternetActive');
  }
}
