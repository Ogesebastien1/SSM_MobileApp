import 'package:flutter/material.dart';
import '../items/workspace_item.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    List<WorkspaceItem> workspaces = [
      WorkspaceItem(name: 'Workspace 1'),
      WorkspaceItem(name: 'Workspace 2'),
      WorkspaceItem(name: 'Workspace 3'),
      WorkspaceItem(name: 'Workspace 4'),
      WorkspaceItem(name: 'Workspace 5'),
      WorkspaceItem(name: 'Workspace 7'),
      WorkspaceItem(name: 'Workspace 8'),
      WorkspaceItem(name: 'Workspace 9'),
      WorkspaceItem(name: 'Workspace 10'),
      WorkspaceItem(name: 'Workspace 11'),
      WorkspaceItem(name: 'Workspace 12'),
      WorkspaceItem(name: 'Workspace 13'),
      WorkspaceItem(name: 'Workspace 14'),
      WorkspaceItem(name: 'Workspace 15'),
      WorkspaceItem(name: 'Workspace 16'),
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/backgroundHomePage.jpeg',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 150, left: 80, right: 8.0, bottom: 8.0), // Added top padding
                  child: Text(
                    'My Workspaces',
                    style: TextStyle(fontSize: 30, color: Colors.white), // Text color
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: (workspaces.length / 2).ceil(),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Handle button click here
                                  print('Button ${workspaces[index].name} clicked.');
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 70, // Adjust height as needed
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color of the button
                                    borderRadius: BorderRadius.circular(10), // Border radius
                                  ),
                                  child: Center(
                                    child: Text(
                                      workspaces[index].name, // Display workspace name
                                      style: const TextStyle(color: Colors.black), // Text color
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: (workspaces.length / 2).floor(),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Handle button click here
                                  print('Button ${workspaces[index + (workspaces.length / 2).ceil()].name} clicked.');
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color of the button
                                    borderRadius: BorderRadius.circular(10), // Border radius
                                  ),
                                  child: Center(
                                    child: Text(
                                      workspaces[index + (workspaces.length / 2).ceil()].name, // Display workspace name
                                      style: const TextStyle(color: Colors.black), // Text color
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
