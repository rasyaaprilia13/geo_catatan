import 'package:latlong2/latlong.dart';

class CatatanModel {
  final double latitude;
  final double longitude;
  final String note;
  final String address;
  final String type; // Tipe catatan (misalnya: 'Rumah', 'Kantor') untuk tugas 1

  CatatanModel({
    required this.latitude,
    required this.longitude,
    required this.note,
    required this.address,
    required this.type,
  });

  // Method getter untuk mengembalikan LatLng
  LatLng get position => LatLng(latitude, longitude);

  // Method factory untuk membuat objek dari LatLng
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

  // tugas 3 : Method untuk mengubah objek ke teks (JSON) disimpan di shared preferences
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'note': note,
    'address': address,
    'type': type,
  };

  // saat memuat data dari shared preferences, saat aplikasi dimulai
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