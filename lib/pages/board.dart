import 'package:flutter/material.dart';

class BoardPage extends StatelessWidget {
  final String name;

  const BoardPage({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name), // Affiche le nom du tableau dans l'AppBar
      ),
      body: Center(
        child: Text('Bienvenue sur le tableau $name'), // Affiche un message de bienvenue avec le nom du tableau
      ),
    );
  }
}