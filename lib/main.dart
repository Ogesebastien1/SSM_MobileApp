import 'package:flutter/material.dart';
import 'pages/home.dart'; 
import 'pages/workspace.dart';
import 'pages/board.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define the theme, title, home, etc... if needed
      routes: {
  '/': (context) => const Home(), // La page d'accueil
  '/workspace': (context) => const Workspace(), // La page de l'espace de travail
  '/board': (context) => const BoardPage(name: 'My Board Name'), // La page du tableau
},

      // Ajoutez d'autres propriétés de MaterialApp si nécessaire
    );
  }
}
