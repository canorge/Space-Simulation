import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uzaysimulasyonu/PlanetPosition.dart';

class GezegenInfo extends StatefulWidget {
  final PlanetPosition? planetPosition;

  const GezegenInfo({super.key, this.planetPosition});

  @override
  State<GezegenInfo> createState() => _GezegenInfoState();
}

class _GezegenInfoState extends State<GezegenInfo> {
  String? summary;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchWikipediaSummary(widget.planetPosition?.name ?? '');
  }

  Future<void> fetchWikipediaSummary(String planetName) async {
    print(planetName);
final query = planetName.trim().split(' ').first;
    final url = Uri.parse(
        'https://en.wikipedia.org/api/rest_v1/page/summary/$query');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          summary = jsonData['extract'] ?? 'Bilgi bulunamadı.';
          loading = false;
        });
      } else {
        setState(() {
          summary = 'Bilgi alınamadı.';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        summary = 'Hata oluştu: $e';
        loading = false;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  final planetName = widget.planetPosition?.name.trim().split(' ').first ?? 'Gezegen';
  final imageFile = "assets/${widget.planetPosition?.name.toLowerCase().replaceAll(' ', '_')}.png";

  return Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/uzay2.png",
          fit: BoxFit.cover,
        ),
        SafeArea(
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          imageFile,
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported,
                                color: Colors.white70, size: 100);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        planetName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white70),
                      const SizedBox(height: 10),
                      Text(
                        summary ?? 'Bilgi yok',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white54),
                      const SizedBox(height: 10),
                      if (widget.planetPosition != null) ...[
                        infoRow("RA (Boylam):",
                            "${widget.planetPosition!.ra.toStringAsFixed(2)}°"),
                        const SizedBox(height: 8),
                        infoRow("Dec (Enlem):",
                            "${widget.planetPosition!.dec.toStringAsFixed(2)}″"),
                        const SizedBox(height: 8),
                        infoRow("Uzaklık:",
                            widget.planetPosition!.distance
                                .toStringAsFixed(2)),
                      ]
                    ],
                  ),
                ),
        ),
      ],
    ),
  );
}


  Widget infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
