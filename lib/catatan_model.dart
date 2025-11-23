import 'package:latlong2/latlong.dart';
// import 'package:hive_flutter/hive_flutter.dart'; // Hapus ini

// Hapus semua anotasi dan 'part' hive
class CatatanModel {
  final double latitude;
  final double longitude;
  final String note;
  final String address;
  final String type; 

  CatatanModel({
    required this.latitude,
    required this.longitude,
    required this.note,
    required this.address,
    required this.type,
  });

  // Helper: Mengubah data lat/lng menjadi objek LatLng
  LatLng get position => LatLng(latitude, longitude);

  // Helper: Constructor dari LatLng
  factory CatatanModel.fromLatLng({
    required LatLng position,
    required String note,
    required String address,
    required String type,
  }) {
    return CatatanModel(
      latitude: position.latitude,
      longitude: position.longitude,
      note: note,
      address: address,
      type: type,
    );
  }

  // ✅ BARU untuk Shared Preferences: Konversi objek ke Map
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'note': note,
    'address': address,
    'type': type,
  };

  // ✅ BARU untuk Shared Preferences: Membuat objek dari Map
  factory CatatanModel.fromJson(Map<String, dynamic> json) {
    return CatatanModel(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      note: json['note'] as String,
      address: json['address'] as String,
      type: json['type'] as String,
    );
  }
}