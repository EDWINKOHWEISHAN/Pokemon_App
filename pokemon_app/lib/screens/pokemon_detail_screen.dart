import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              pokemon.imageUrl,
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'Types: ${pokemon.types.join(", ")}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Stats:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...pokemon.stats.entries.map((stat) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stat.key,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        stat.value.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
} 