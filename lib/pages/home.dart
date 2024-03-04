import 'package:flutter/material.dart';
import '../items/Workspace.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.only(top: 150, left: 80, right: 8.0, bottom: 8.0),
                  child: Text(
                    'My Workspaces',
                    style: TextStyle(fontSize: 30, color: Colors.white),
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
                            return workspaceButton(index);
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: (workspaces.length / 2).floor(),
                          itemBuilder: (BuildContext context, int index) {
                            return workspaceButton(index + (workspaces.length / 2).ceil());
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new workspace
          setState(() {
            workspaces.add(WorkspaceItem(name: 'New Workspace'));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget workspaceButton(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Edit Workspace'),
                      onTap: () {
                        // Implement edit functionality here
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete Workspace'),
                      onTap: () {
                        // Implement delete functionality here
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.open_in_browser),
                      title: const Text('Open Workspace'),
                      onTap: () {
                        Navigator.pop(context); // Close the bottom sheet
                        Navigator.pushNamed(context, '/workspace');
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              workspaces[index].name,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}