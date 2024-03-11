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
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/backgroundHomePage.jpeg',
          fit: BoxFit.cover,
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          child: SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 150, left: 80, right: 8.0, bottom: 8.0),
                  child: Text(
                    'My Board',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16.0),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateBoardDialog();
        },
        child: const Icon(Icons.add),
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
                        showEditBoard(boards[index].id, boards[index].name);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete Board'),
                      onTap: () {
                        deleteBoard(boards[index].id);
                        Navigator.pop(context);
                        fetchData();
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
                            builder: (context) => BoardPage(name: boards[index].name),
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

  void showCreateBoardDialog() async {
    TextEditingController nameController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Board'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Enter Board name'),
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
                    await addBoard(newName, widget.workspaceId);
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