import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uzaysimulasyonu/GezegenInfo.dart';
import 'package:uzaysimulasyonu/PlanetPosition.dart';
import 'package:uzaysimulasyonu/StepMotor.dart';

class Gezegen extends StatefulWidget {
  const Gezegen({super.key});

  @override
  State<Gezegen> createState() => _GezegenState();
}

class _GezegenState extends State<Gezegen> {
  final String apiBaseUrl = 'http://localhost:8000';

  Future<PlanetPosition?> fetchPlanetPosition(String planetName) async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/planet_position/$planetName'),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PlanetPosition.fromJson(planetName, jsonData);
      }
    } catch (e) {
      debugPrint('Fetch hata: $e');
    }
    return null;
  }

  final Map<String, String> items = {
    'sun': 'Güneş',
    'uranus barycenter': 'Uranüs',
    'venus': 'Venüs',
    'saturn barycenter': 'Satürn',
    'neptune barycenter': 'Neptün',
    'mercury': 'Merkür',
    'mars': 'Mars',
    'jupiter barycenter': 'Jüpiter',
    'earth': 'Dünya',
    'moon': 'Ay',
    'polaris': 'Polaris',
  };

  String? selectedValue = 'polaris';
  String? nextValue = 'polaris';
  PlanetPosition? currentPosition;
  PlanetPosition? nextPosition;
  bool isMoving = false;

  final StepMotor stepMotor = StepMotor();

  @override
  void initState() {
    super.initState();
    _loadPosition(selectedValue!);
  }

  Future<void> _loadPosition(String planetName) async {
    setState(() {
      isMoving = true;
    });

    // Hedef pozisyonu çek
    final pos = await fetchPlanetPosition(planetName);

    if (pos != null) {
      setState(() {
        nextPosition = pos; // hedef pozisyonu burada kaydet
      });

      // Motoru hedef pozisyona döndür
      await stepMotor.moveTo(
        pos.ra,
        onStep: (angle) {
          setState(() {
            stepMotor.currentAngle = angle;
          });
        },
      );

      // Hareket tamamlandıktan sonra artık oraya ulaştık → current = next
      setState(() {
        currentPosition = pos;
        selectedValue = nextValue; // dropdown'da da seçim kalıcı olsun
      });
    }

    setState(() {
      isMoving = false;
    });
  }

  Widget movingUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "🚀 Hareket Ediyor...",
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "${items[selectedValue] ?? selectedValue} gezegeninden, "
          "${items[nextValue] ?? nextValue} gezegenine gidiliyor...",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mevcut RA:",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Text(
                    "${currentPosition?.ra.toStringAsFixed(2)}°",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hedef RA:",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Text(
                    "${nextPosition?.ra.toStringAsFixed(2) ?? '...'}°",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mevcut DEC:",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Text(
                    "${currentPosition?.dec.toStringAsFixed(2)}°",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hedef DEC:",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Text(
                    "${nextPosition?.dec.toStringAsFixed(2) ?? '...'}°",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mevcut Uzaklık:",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Text(
                    "${currentPosition?.distance.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hedef Uzaklık:",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Text(
                    "${nextPosition?.distance.toStringAsFixed(2) ?? '...'}",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        Transform.rotate(
          angle: stepMotor.currentAngle * (3.141592 / 180),
          child: Image.asset("assets/pusula.png", height: 150, width: 150),
        ),
      ],
    );
  }

  Widget normalUI() {
    selectedValue = nextValue;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          items[selectedValue] ?? 'Yıldız',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        Text(
          "Sağ Açıklık(Boylam): ${currentPosition!.ra.toStringAsFixed(2)}°",
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        Text(
          "Açıklık (Enlem): ${currentPosition!.dec.toStringAsFixed(2)}″",
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        Text(
          "Uzaklık: ${currentPosition!.distance.toStringAsFixed(2)}",
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        const SizedBox(height: 30),
        Image.asset(
          "assets/${selectedValue?.replaceAll(' ', '_')}.png",
          height: 200,
          width: 200,
        ),
        const SizedBox(height: 20),
        DropdownButton<String>(
          hint: const Text('Bir Yıldız Seçin'),
          value: selectedValue,
          onChanged: isMoving
              ? null
              : (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      nextValue = newValue;
                    });
                    _loadPosition(newValue);
                  }
                },
          items: items.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: isMoving
              ? null
              : () async {
                  if (selectedValue != null) {
                    await _loadPosition(selectedValue!);

                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GezegenInfo(planetPosition: currentPosition),
                      ),
                    );
                  }
                },
          child: isMoving ? const Text("Hareket Ediyor...") : const Text("Git"),
        ),
        const SizedBox(height: 20),
        Transform.rotate(
          angle: stepMotor.currentAngle * (3.141592 / 180),
          child: Image.asset("assets/pusula.png", height: 200, width: 200),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/uzay2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          minimum: EdgeInsets.zero,
          child: currentPosition == null
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : isMoving
              ? movingUI()
              : normalUI(),
        ),
      ),
    );
  }
}
