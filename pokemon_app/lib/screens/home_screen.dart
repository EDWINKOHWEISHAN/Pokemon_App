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
          if (pokemonProvider.evolutionChains.isEmpty && !pokemonProvider.isLoading) {
            pokemonProvider.fetchPokemons();
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: pokemonProvider.evolutionChains.length + (pokemonProvider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == pokemonProvider.evolutionChains.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final evolutionChain = pokemonProvider.evolutionChains[index];
              return Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var pokemon in evolutionChain)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PokemonDetailScreen(pokemon: pokemon),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  pokemon.imageUrl,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  pokemon.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (evolutionChain.length < 3)
                      for (var i = 0; i < 3 - evolutionChain.length; i++)
                        Expanded(
                          child: Container(),
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