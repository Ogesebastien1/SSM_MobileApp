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
  // ignore: library_private_types_in_public_api
  _WorkspaceState createState() => _WorkspaceState();
}

class _WorkspaceState extends State<Workspace> {
  List<BoardItem> boards = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      List<dynamic> boardMaps = await getWorkspaceBoards(widget.workspaceId);
      List<BoardItem> boardItems =
          boardMaps.map((boardMap) => BoardItem.fromMap(boardMap)).toList();

      setState(() {
        boards = boardItems;
      });
    } catch (error) {
      // ignore: avoid_print
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/j.jpg',
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    color: const Color.fromARGB(255, 27, 73, 75).withOpacity(0.9),
                    margin: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'My Boards',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                      showCreateBoardDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 27, 73, 75).withOpacity(0.9),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Create new board',
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
                    itemCount: boards.length,
                    itemBuilder: (BuildContext context, int index) {
                      return boardButton(index);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 73, 75).withOpacity(0.9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Workspaces', // Added text "Workspaces"
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                        Navigator.pop(context);
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
                boards[index].name,
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

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 27, 73, 75),
        title: const Text(
          'Create New Board',
          style: TextStyle(color: Colors.black),
        ),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Enter Board name',
            hintStyle: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text(
              'Create',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              var newName = nameController.text;
              if (newName.isNotEmpty) {
                try {
                  await addBoard(newName, widget.workspaceId);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  fetchData();
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 8, 43, 45),
          title: const Text(
            'Edit Board',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(hintText: "Enter new name"),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                try {
                  await updateBoard(boardId, nameController.text);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  fetchData();
                } catch (e) {
                  if (e.toString().contains("Board short name is taken")) {
                    showErrorDialog("The Board name is already taken. Please choose a different name.");
                  } else {
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

