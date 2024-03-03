import 'package:flutter/material.dart';
import 'package:ssm_oversight/pages/board.dart';
import 'package:ssm_oversight/pages/workspace.dart';
import './pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const Home(),
        '/workspace': (context) => const WorkspacePage(),
        '/board': (context) => const BoardPage(),
      },
    );
  }
}

