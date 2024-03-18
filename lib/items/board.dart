import 'package:flutter/material.dart';

// Define a class for the board item
class BoardItem {
  final String id;
  final String name;

  BoardItem({required this.id, required this.name});

  factory BoardItem.fromMap(Map<String, dynamic> map) {
    return BoardItem(
      id: map['id'], //'id' is the key in the response
      name: map['name'],
    );
  }
}


// Define a class to represent a board template
class BoardTemplate {
  final String templateId;
  final String displayName;

  BoardTemplate({
    required this.templateId,
    required this.displayName,
  });

  get templateBoardId => null;
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