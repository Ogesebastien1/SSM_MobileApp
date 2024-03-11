import 'package:flutter/material.dart';

// Define a class for the workspace item
class WorkspaceItem {
  final String id;
  final String name;


  WorkspaceItem({required this.id, required this.name});

  factory WorkspaceItem.fromMap(Map<String, dynamic> map) {
    return WorkspaceItem(
      id: map['id'], //'id' is the key in the response
      name: map['name'],
    );
  }
}

// Custom widget representing the workspace item.
class WorkspaceButton extends StatelessWidget {
  final WorkspaceItem workspace;

  const WorkspaceButton({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workspace.name,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}