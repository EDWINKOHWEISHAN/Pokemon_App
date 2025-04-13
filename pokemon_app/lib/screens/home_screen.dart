import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../models/pokemon.dart';
import 'pokemon_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      Provider.of<PokemonProvider>(context, listen: false).loadMorePokemons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon App'),
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, pokemonProvider, child) {
          if (pokemonProvider.pokemons.isEmpty && !pokemonProvider.isLoading) {
            pokemonProvider.fetchPokemons();
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: (pokemonProvider.pokemons.length / 3).ceil() + (pokemonProvider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == (pokemonProvider.pokemons.length / 3).ceil()) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < 3; i++)
                      if (index * 3 + i < pokemonProvider.pokemons.length)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PokemonDetailScreen(
                                    pokemon: pokemonProvider.pokemons[index * 3 + i],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    pokemonProvider.pokemons[index * 3 + i].imageUrl,
                                    height: 150,
                                    width: 150,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    pokemonProvider.pokemons[index * 3 + i].name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
} 