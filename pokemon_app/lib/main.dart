import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pokemon_provider.dart';
import 'screens/home_screen.dart'; // Introducing home page interface components

// The pokemon_provider is used to manage the application state, and the theme
void main() {
  runApp(const MyApp()); // Start the entire application
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ChangeNotifierProvider to inject PokemonProvider into the entire component tree so that child components can access and monitor state changes of pokemon data.
    return ChangeNotifierProvider(
      create: (context) => PokemonProvider(),
      child: MaterialApp(
        title: 'Pokemon App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3B4CCA),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF3B4CCA),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
