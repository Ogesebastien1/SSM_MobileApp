import 'package:flutter/material.dart';
import '../items/workspace.dart';
import '../services/read.dart';
import '../services/update.dart';
import '../services/delete.dart';
import '../services/create.dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<WorkspaceItem> workspaces = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      List<dynamic> workspaceMaps = await getWorkspaces();
      List<WorkspaceItem> workspaceItems = workspaceMaps.map((workspaceMap) {
        return WorkspaceItem.fromMap(workspaceMap as Map<String, dynamic>);
      }).toList();

      setState(() {
        workspaces = workspaceItems;
      });
    } catch (error) {
      print('An error occurred: $error');
    }
  }

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
                padding: EdgeInsets.only(top: 150, left: 8.0, right: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'My Workspaces',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    // The function to show the dialog for creating a new workspace
                    showCreateWorkspaceDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                    shape: StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  ),
                  child: const Text('Create new workspace'),
                ),
              ),
              const SizedBox(height: 20), // Adjust the space as needed
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
                        Navigator.pop(context); // Close the bottom sheet first
                        var workspaceId = workspaces[index].id; // Assuming WorkspaceItem has an 'id' property
                        showEditDialog(workspaceId, workspaces[index].displayName);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete Workspace'),
                      onTap: () {
                        deleteWorkspaceItem(workspaces[index].id);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.open_in_browser),
                      title: const Text('Open Workspace'),
                      onTap: () {
                        Navigator.pop(context); 
                        Navigator.pushNamed(context, '/workspace', arguments: {'workspaceId': workspaces[index].id},);
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
              workspaces[index].displayName,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showEditDialog(String workspaceId, String currentName) async {
    TextEditingController nameController = TextEditingController(text: currentName);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Workspace'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: "Enter new name"),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                try {
                  await updateWorkspaceName(workspaceId, nameController.text);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop(); // Close the dialog
                    fetchData(); // Refresh workspace list
                } catch (e) {
                  if (e.toString().contains("Organization short name is taken")) {
                    // Handle the specific error, e.g., show an error message to the user
                    showErrorDialog("The workspace name is already taken. Please choose a different name.");
                  } else {
                    // Handle other errors
                    showErrorDialog("An error occurred while updating the workspace.");
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteWorkspaceItem(String workspaceId) async {
    try {
      await deleteWorkspace(workspaceId);
      fetchData(); // Refresh the list of workspaces after deletion
    } catch (e) {
      showErrorDialog("Failed to delete workspace: $e");
    }
  }

  void showCreateWorkspaceDialog() async {
    TextEditingController nameController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Workspace'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Enter workspace name'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () async {
                final String newName = nameController.text;
                if (newName.isNotEmpty) {
                  try {
                    await addWorkspace(newName);
                    Navigator.pop(context); // Close the dialog
                    fetchData(); // Refresh the list of workspaces
                  } catch (e) {
                    showErrorDialog('Failed to create the workspace: $e');
                  }
                } else {
                  showErrorDialog('Name cannot be empty.');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
