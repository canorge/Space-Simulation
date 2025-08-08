import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uzaysimulasyonu/Gezegen.dart';
import 'package:uzaysimulasyonu/PlanetPosition.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpaceTransitionPage(),
    );
  }
}

class SpaceTransitionPage extends StatefulWidget {
  const SpaceTransitionPage({super.key});

  @override
  State<SpaceTransitionPage> createState() => _SpaceTransitionPageState();
}

class _SpaceTransitionPageState extends State<SpaceTransitionPage>
    with SingleTickerProviderStateMixin {
  bool showSpace = false;
  double initialDragY = 0;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  List<PlanetPosition> _planetPositions = [];

  final String apiBaseUrl = 'http://localhost:8000'; // API adresi

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        fetchAllPlanetPositions();
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _planetPositions.clear();
        });
      }
    });
  }


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

  Future<void> fetchAllPlanetPositions() async {
    final planets = [
      'mars',
      'jupiter barycenter',
      'venus',
      'saturn barycenter',
      'mercury',
      'earth',

      'uranus barycenter',
      'neptune barycenter',
      'pluto barycenter',
      'sun',
      'polaris',
    ];
    List<PlanetPosition> positions = [];

    for (var planet in planets) {
      final pos = await fetchPlanetPosition(planet);
      if (pos != null) {
        positions.add(pos);
      }
    }

    setState(() {
      _planetPositions = positions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Gezegen(),
    );
  }
}
