import 'package:flutter/material.dart';

// Define a class for the workspace item
class WorkspaceItem {
  final String name;

  WorkspaceItem({required this.name});
}

// Custom widget representing the workspace item
class WorkspaceButton extends StatelessWidget {
  final WorkspaceItem workspace;

  const WorkspaceButton({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Perform action when the workspace button is pressed
        print('Workspace ${workspace.name} pressed');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workspace.name,
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}