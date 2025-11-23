import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// Tugas 3: Import Shared Preferences dan dart:convert untuk menyimpan dan memuat data
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'catatan_model.dart';

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
  List<CatatanModel> _savedNotes = []; 
  final MapController _mapController = MapController();
  
  // untuk menyimpan catatan
  static const String _NOTES_KEY = 'saved_notes'; 

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // fungsi untuk simpan dan memuat catatan
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString(_NOTES_KEY);

    if (notesString != null && notesString.isNotEmpty) {
      final List<dynamic> notesJson = jsonDecode(notesString);
      setState(() {
        _savedNotes = notesJson
            .map((json) => CatatanModel.fromJson(json as Map<String, dynamic>))
            .toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> notesJson = _savedNotes.map((note) => note.toJson()).toList();
    await prefs.setString(_NOTES_KEY, jsonEncode(notesJson));
  }
  
  // tugas 1 : memilih icon berdasarkan type
  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'shop':
        return Icons.store;
      case 'office':
        return Icons.work;
      default:
        return Icons.location_on;
    }
  }

  // Fungsi lokasi saat ini
  Future<void> _findMyLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition();

    _mapController.move(
      latlong.LatLng(position.latitude, position.longitude),
      15.0,
    );
  }

  // tugas 2 : menampilkan dialog konfirmasi penghapusan
  Future<void> _showDeleteConfirmation(int index, CatatanModel note) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Catatan?'),
          content: Text('Hapus catatan "${note.note}" (${note.type.toUpperCase()}) di alamat:\n${note.address}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                setState(() {
                  // Tugas 2: Hapus item dari daftar
                  _savedNotes.removeAt(index); 
                });
                // Tugas 3: Simpan data setelah penghapusan
                _saveNotes(); 
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  // tugas 1 : menampilkan dialog input catatan dan jenis
  Future<void> _showNoteDialog(latlong.LatLng point, String address) async {
  String noteType = "other";

  await showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Pilih Jenis Catatan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Alamat: $address', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Dropdown sederhana tanpa ValueNotifier
            DropdownButton<String>(
              value: noteType,
              items: ['other', 'home', 'shop', 'office']
                  .map((val) => DropdownMenuItem(value: val, child: Text(val.toUpperCase())))
                  .toList(),
              onChanged: (val) {
                if (val != null) noteType = val;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // langsung simpan tanpa isi note
              setState(() {
                _savedNotes.add(CatatanModel.fromLatLng(
                  position: point,
                  note: "",              
                  address: address,
                  type: noteType,
                ));
              });
              _saveNotes();
              Navigator.of(context).pop();
            },
            child: const Text('Simpan'),
          ),
        ],
      );
    },
  );
}


  // tambahkan catatan
  void _handleLongPress(TapPosition _, latlong.LatLng point) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      point.latitude,
      point.longitude,
    );
    String address = placemarks.first.street ?? "Alamat tidak dikenal";

    await _showNoteDialog(point, address);
  }

  @override
  Widget build(BuildContext context) {
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
          onLongPress: _handleLongPress, 
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.geocatatn', 
          ),
          
          // Implementasi Tugas 1 & 2
          MarkerLayer(
            // Tugas 3: Marker diambil dari _savedNotes (data Shared Preferences)
            markers: _savedNotes.asMap().entries.map((entry) {
              int index = entry.key;
              CatatanModel note = entry.value;
              
              return Marker(
                point: note.position,
                child: GestureDetector(
                  // Tugas 2: Tap marker akan memanggil konfirmasi penghapusan
                  onTap: () => _showDeleteConfirmation(index, note), 
                  child: Icon(
                    // Tugas 1: Ikon disesuaikan berdasarkan jenis catatan
                    _getIconForType(note.type),
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _findMyLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}