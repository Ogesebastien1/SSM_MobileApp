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
        // Image de fond
        Image.asset(
          'assets/images/j.jpg',
          fit: BoxFit.cover,
        ),
        // Colonne pour le contenu
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Espace pour créer un espace en haut de l'écran
            const SizedBox(height: 48.0),
            // Alignement pour centrer la carte horizontalement
            Align(
              alignment: Alignment.topCenter,
              child: Card(
                color: const Color.fromARGB(255, 27, 73, 75).withOpacity(0.9), 
                margin: const EdgeInsets.symmetric(horizontal: 32.0), 
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'My Workspaces',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Couleur du texte à l'intérieur de la carte
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 11.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Fonction pour afficher la boîte de dialogue de création d'un nouvel espace de travail
                  showCreateWorkspaceDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 27, 73, 75).withOpacity(0.9),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Create a new workspace',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: workspaces.length,
                itemBuilder: (BuildContext context, int index) {
                  return workspaceButton(index);
                },
              ),
            ),
          ],
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
              decoration: const BoxDecoration(
        color: Color.fromARGB(255, 94, 150, 142), 
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
 ),

              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Workspace'),
                    onTap: () {
                      Navigator.pop(context); // Close the bottom sheet first
                      var workspaceId = workspaces[index].id;
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
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: 70,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 27, 94, 97).withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              workspaces[index].displayName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
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
        backgroundColor: const Color.fromARGB(255, 8, 43, 45), // Set background color
        title: const Text(
          'Edit Workspace',
          style: TextStyle(color: Colors.white), // Text color
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: const InputDecoration(
                  hintText: "Enter new name",
                  hintStyle: TextStyle(color: Colors.white70), // Hint text color
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white), // Button text color
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.white), // Button text color
            ),
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
      fetchData(); 
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
        backgroundColor: const Color.fromARGB(255, 27, 73, 75), // Set background color
        title: const Text(
          'Create a New Workspace',
          style: TextStyle(color: Colors.black), // Text color
        ),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.black), // Text color
          decoration: const InputDecoration(
            hintText: 'Enter your workspace name',
            hintStyle: TextStyle(color: Colors.black), // Hint text color
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black), // Button text color
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text(
              'Create',
              style: TextStyle(color: Colors.black), // Button text color
            ),
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
}}
