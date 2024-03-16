import 'package:flutter/material.dart';
import 'pages/home.dart'; 
import 'pages/workspace.dart';
import 'pages/board.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define the theme, title, home, etc... if needed
      routes: {
      '/': (context) => const Home(), // the home page
      '/workspace': (context) {
        // Retrieve the workspace ID passed as an argument
        final args = ModalRoute.of(context)!.settings.arguments as Map;
        final workspaceId = args['workspaceId'];
        return Workspace(workspaceId: workspaceId);
      },
      '/board': (context) {
        // Retrieve the workspace ID passed as an argument
        final arguments = ModalRoute.of(context)!.settings.arguments as Map;
        final boardId = arguments['boardId'];
        final boardName = arguments['name'];
        return BoardPage(boardId: boardId, name: boardName,); // the board page
      },
    });
  }
}
