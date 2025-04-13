import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonProvider with ChangeNotifier {
  List<List<Pokemon>> _evolutionChains = [];
  bool _isLoading = false;
  int _currentPage = 1;
  static const int _pageSize = 10; // 10 evolution chains

  List<List<Pokemon>> get evolutionChains => _evolutionChains;
  bool get isLoading => _isLoading;

  Future<List<Pokemon>> _fetchEvolutionChain(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final chain = data['chain'];
        List<Pokemon> evolutions = [];
        
        var current = chain;
        int order = 0;
        while (current != null) {
          final speciesUrl = current['species']['url'];
          final speciesResponse = await http.get(Uri.parse(speciesUrl));
          if (speciesResponse.statusCode == 200) {
            final speciesData = json.decode(speciesResponse.body);
            final pokemonResponse = await http.get(Uri.parse(speciesData['varieties'][0]['pokemon']['url']));
            if (pokemonResponse.statusCode == 200) {
              final pokemonData = json.decode(pokemonResponse.body);
              evolutions.add(Pokemon.fromJson(pokemonData, evolutionOrder: order));
            }
          }
          current = current['evolves_to']?.isNotEmpty == true ? current['evolves_to'][0] : null;
          order++;
        }
        
        return evolutions;
      }
    } catch (e) {
      print('Error fetching evolution chain: $e');
    }
    return [];
  }

  Future<void> fetchPokemons() async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$_pageSize&offset=${(_currentPage - 1) * _pageSize}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        for (var result in results) {
          final pokemonResponse = await http.get(Uri.parse(result['url']));
          if (pokemonResponse.statusCode == 200) {
            final pokemonData = json.decode(pokemonResponse.body);
            final speciesResponse = await http.get(Uri.parse(pokemonData['species']['url']));
            if (speciesResponse.statusCode == 200) {
              final speciesData = json.decode(speciesResponse.body);
              final evolutionChain = await _fetchEvolutionChain(speciesData['evolution_chain']['url']);
              
              if (evolutionChain.isNotEmpty && !_isChainAlreadyAdded(evolutionChain[0].id)) {
                _evolutionChains.add(evolutionChain);
              }
            }
          }
        }

        _currentPage++;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching pokemons: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isChainAlreadyAdded(int firstPokemonId) {
    return _evolutionChains.any((chain) => chain.isNotEmpty && chain[0].id == firstPokemonId);
  }

  Future<void> loadMorePokemons() async {
    await fetchPokemons();
  }
} 