import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  LatLngBounds bounds;
  List<PointLatLng>? polylinePoints;
  String? totalDistance;
  String? totalDuration;

  Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    if ((map['routes'] as List).isEmpty) {
      return Directions(
          bounds:
              LatLngBounds(northeast: LatLng(0, 0), southwest: LatLng(0, 0)),
          polylinePoints: null,
          totalDistance: null,
          totalDuration: null);
    }
    final data = Map<String, dynamic>.from(map['routes'][0]);

    final ne = data['bounds']['northeast'];
    final sw = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(ne['lat'], ne['lng']),
      southwest: LatLng(sw['lat'], sw['lng']),
    );

    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
        bounds: bounds,
        polylinePoints: PolylinePoints()
            .decodePolyline(data['overview_polyline']['points']),
        totalDistance: distance,
        totalDuration: duration);
  }
}
