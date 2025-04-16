class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final Map<String, dynamic> stats;
  final int
      evolutionOrder; // 0: initial form, 1: first evolution, 2: final form

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.stats, // Ability values ​​(such as HP)
    required this.evolutionOrder,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json,
      {int evolutionOrder = 0}) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      stats: {
        'hp': json['stats'][0]['base_stat'],
        'attack': json['stats'][1]['base_stat'],
        'defense': json['stats'][2]['base_stat'],
        'special-attack': json['stats'][3]['base_stat'],
        'special-defense': json['stats'][4]['base_stat'],
        'speed': json['stats'][5]['base_stat'],
      },
      evolutionOrder: evolutionOrder,
    );
  }
}
