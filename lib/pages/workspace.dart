import 'package:flutter/material.dart';
import 'package:ssm_oversight/items/board.dart';
import 'package:ssm_oversight/pages/board.dart';
import '../services/read.dart';
import '../services/update.dart';
import '../services/delete.dart';
import '../services/create.dart';

class Workspace extends StatefulWidget {

  final String workspaceId;

  const Workspace({super.key, required this.workspaceId});

  @override
  WorkspaceState createState() => WorkspaceState();
}

class WorkspaceState extends State<Workspace> {
  List<BoardItem> boards = [];
  bool createFromTemplate = false;
  

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      List<dynamic> boardMaps = await getWorkspaceBoards(widget.workspaceId);
      List<BoardItem> boardItems = boardMaps.map((boardMap) {
        return BoardItem.fromMap(boardMap as Map<String, dynamic>);
      }).toList();

      setState(() {
        boards = boardItems;
      });
    } catch (error) {
      print('An error occurred: $error');
    }
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Workspace'),
    ),
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
                    'My Boards',
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
                    showCreateBoardDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                    shape: StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  ),
                  child: const Text('Create new board'),
                ),
              ),
              const SizedBox(height: 20), // Adjust the space as needed
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: (boards.length / 2).ceil(),
                            itemBuilder: (BuildContext context, int index) {
                              return boardButton(index);
                            },
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: ListView.builder(
                            itemCount: (boards.length / 2).floor(),
                            itemBuilder: (BuildContext context, int index) {
                              return boardButton(index + (boards.length / 2).ceil());
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

  Widget boardButton(int index) {
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
                      title: const Text('Edit Board'),
                      onTap: () {
                        Navigator.pop(context);
                        showEditBoard(boards[index].id, boards[index].name);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete Board'),
                      onTap: () {
                        deleteBoardItem(boards[index].id);
                        Navigator.pop(context);
                      },
                    ),
                     ListTile(
                      leading: const Icon(Icons.open_in_browser),
                      title: const Text('Open Board'),
                      onTap: () {
                        Navigator.pop(context); // Close the bottom sheet
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoardPage(boardId: boards[index].id, name: boards[index].name),
                          ),
                        );
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
              boards[index].name,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  void deleteBoardItem(String boardId) async {
    try {
      await deleteBoard(boardId);
      fetchData();
    } catch (e) {
      showErrorDialog("Failed to delete board: $e");
    }
  }

  void showCreateBoardDialog() async {
  TextEditingController nameController = TextEditingController();
  String? selectedTemplate = 'Without template'; // Default selection

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Create New Board'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Enter Board name'),
                ),
                DropdownButton<String>(
                  value: selectedTemplate,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTemplate = newValue!;
                    });
                  },
                  items: <String>['Without template', 'Agile', 'Go-to-market strategy', 'Kanban'] // Updated with 'Without template' option
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            );
          },
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
              var newName = nameController.text;
              if (newName.isNotEmpty) {
                try {
                  if (selectedTemplate != 'Without template') { // Check if template is selected
                    var templateId; // Define templateId based on selectedTemplate
                    // Set templateId based on selectedTemplate
                    if (selectedTemplate == 'Agile') {
                      templateId = '54c93f6f836da7c4865460d2'; // Agile template ID
                       print('creating template Agile');
                    } else if (selectedTemplate == 'Go-to-market strategy') {
                      templateId = '57e1548d041d8599c91361f5'; // Project management
                    } else if (selectedTemplate == 'Kanban') {
                      templateId = '5e20e06c460b391727ce7a2b'; // Kanban template ID
                    }
                    print('creating template');
                    // Create board from the selected template
                    await createBoardFromTemplate(templateId, widget.workspaceId, newName);
                  } else {
                    // If 'Without template' selected, create a board without a template
                    await addBoard(newName, widget.workspaceId);
                  }
                  Navigator.pop(context); // Close the dialog
                  fetchData(); // Refresh the list of workspaces
                } catch (e) {
                  showErrorDialog('Failed to create the Board: $e');
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


  Future<void> showEditBoard(String boardId, String currentName) async {
      TextEditingController nameController = TextEditingController(text: currentName);
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Board'),
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
                    await updateBoard(boardId, nameController.text);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop(); // Close the dialog
                      fetchData();
                  } catch (e) {
                    if (e.toString().contains("Board short name is taken")) {
                      // Handle the specific error, e.g., show an error message to the user
                      showErrorDialog("The Board name is already taken. Please choose a different name.");
                    } else {
                      // Handle other errors
                      showErrorDialog("An error occurred while updating the Board.");
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
}