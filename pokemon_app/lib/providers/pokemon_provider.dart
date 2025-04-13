import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonProvider with ChangeNotifier {
  List<Pokemon> _pokemons = [];
  bool _isLoading = false;
  int _currentPage = 1;
  static const int _pageSize = 30; // 3 per row, 10 rows

  List<Pokemon> get pokemons => _pokemons;
  bool get isLoading => _isLoading;

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
            _pokemons.add(Pokemon.fromJson(pokemonData));
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

  Future<void> loadMorePokemons() async {
    await fetchPokemons();
  }
} 