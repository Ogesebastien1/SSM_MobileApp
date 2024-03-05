import 'package:flutter/material.dart';

// Define a class for the board item
class BoardItem {
  final String name;

  BoardItem({required this.name});
}

// Custom widget representing the board item.
class BoardButton extends StatelessWidget {
  final BoardItem board;

  const BoardButton({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Add navigation logic here if needed
      },
      child: Text(
        board.name,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}