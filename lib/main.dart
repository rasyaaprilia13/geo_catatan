// Import paket yang dibutuhkan
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'catatan_model.dart'; // Menggunakan model yang sudah kita buat

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Geo-Catatan",
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Menyimpan daftar CatatanModel
  final List<CatatanModel> _savedNotes = [];
  final MapController _mapController = MapController();

  // --- Fungsi untuk mendapatkan lokasi saat ini ---
  Future<void> _findMyLocation() async {
    // 1. Cek layanan GPS aktif
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Idealnya tampilkan pesan error ke pengguna
      return;
    }

    // 2. Cek dan minta izin lokasi
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Idealnya tampilkan pesan error ke pengguna
        return;
      }
    }

    // 3. Ambil posisi
    Position position = await Geolocator.getCurrentPosition();

    // 4. Pindahkan kamera peta ke posisi saat ini
    _mapController.move(
      latlong.LatLng(position.latitude, position.longitude),
      15.0, // Zoom level
    );
  }

  // --- Fungsi menangani Long Press pada peta ---
  void _handleLongPress(TapPosition _, latlong.LatLng point) async {
    // Reverse Geocoding (Koordinat -> Alamat)
    List<Placemark> placemarks = await placemarkFromCoordinates(
      point.latitude,
      point.longitude,
    );

    // Dapatkan nama jalan/alamat dari hasil geocoding
    String address = placemarks.isNotEmpty
        ? placemarks.first.street ?? "Alamat tidak dikenal"
        : "Alamat tidak ditemukan";

    // Tampilkan Dialog (Bagian ini perlu diimplementasikan,
    // tapi untuk saat ini, kita langsung menyimpan catatan default)
    // ... Implementasi Dialog untuk input Catatan pengguna ...

    // Tambahkan catatan baru ke daftar dan perbarui UI
    setState(() {
      _savedNotes.add(CatatanModel(
        position: point,
        note: "Catatan Baru (${_savedNotes.length + 1})", // Contoh default note
        address: address,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Posisi awal peta (misalnya, Jakarta)
    const latlong.LatLng initialPosition = latlong.LatLng(-6.2, 106.8);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Geo-Catatan"),
        backgroundColor: Colors.blueGrey,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: initialPosition,
          initialZoom: 13.0,
          onLongPress: _handleLongPress, // Panggil fungsi saat long press
        ),
        children: [
          // 1. Lapisan Peta (OpenStreetMap)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.geocatatn', // Wajib untuk TileLayer
          ),
          // 2. Lapisan Marker (Pin lokasi catatan)
          MarkerLayer(
            markers: _savedNotes.map((n) => Marker(
                  point: n.position,
                  // Tampilkan marker dan info/label
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                )).toList(),
          ),
        ],
      ),
      // Tombol untuk mencari lokasi saat ini
      floatingActionButton: FloatingActionButton(
        onPressed: _findMyLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}