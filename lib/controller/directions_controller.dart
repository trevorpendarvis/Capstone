import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monkey_management/model/directions.dart';

class DirectionsController {
  static const String baseURL =
      'https://maps.googleapis.com/maps/api/directions/json?';
  static const String googleAPIKEY = 'AIzaSyBA4uPdUZt3T6czzzgkbiyIWeuYlwk6j3o';
  final Dio? _dio;

  DirectionsController({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng userLocation,
    required LatLng storesLocation,
  }) async {
    final response = await _dio!.get(baseURL, queryParameters: {
      'origin': '${userLocation.latitude},${userLocation.longitude}',
      'destination': '${storesLocation.latitude},${storesLocation.longitude}',
      'key': googleAPIKEY,
    });

    _dio!.close();

    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }


}
