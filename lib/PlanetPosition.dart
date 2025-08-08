class PlanetPosition {
  final String name;
  final double ra; // Sağ yükselim (derece)
  final double dec; // Dik açıklık (derece)
  final double distance;
  PlanetPosition({required this.name, required this.ra, required this.dec, required this.distance});

  factory PlanetPosition.fromJson(String name, Map<String, dynamic> json) {
    return PlanetPosition(name: name, ra: json['ra'], dec: json['dec'],distance: json['distance_au']);
  }
}