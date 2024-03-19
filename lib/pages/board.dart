import 'package:flutter/material.dart';
import 'package:ssm_oversight/items/card.dart';
import 'package:ssm_oversight/items/list.dart';
import '../services/read.dart';
import '../services/update.dart';
import '../services/create.dart';
import '../services/delete.dart';

class BoardPage extends StatefulWidget {
  final String boardId;
  final String name;

  const BoardPage({Key? key, required this.boardId, required this.name}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _cardTitleController = TextEditingController();
  final TextEditingController _cardDescriptionController = TextEditingController();
  final TextEditingController _editListNameController = TextEditingController();
  final TextEditingController _editCardTitleController = TextEditingController();
  final TextEditingController _editCardDescriptionController = TextEditingController();
  List<ListItem> _lists = [];
  List<CardItem> _cards = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      List<dynamic> listMaps = await getBoardLists(widget.boardId);
      List<ListItem> listItems = listMaps.map((listMap) {
        return ListItem.fromMap(listMap as Map<String, dynamic>);
      }).toList();

      List<dynamic> cardMaps = await getBoardCards(widget.boardId);
      List<CardItem> cardItems = cardMaps.map((cardMap) {
        return CardItem.fromMap(cardMap as Map<String, dynamic>);
      }).toList();

      setState(() {
        _cards = cardItems;
        _lists = listItems;
      });
    } catch (error) {
      // ignore: avoid_print
      print('An error occurred: $error');
    }
  }

  @override
  void dispose() {
    _listNameController.dispose();
    _cardTitleController.dispose();
    _cardDescriptionController.dispose();
    _editListNameController.dispose();
    _editCardTitleController.dispose();
    _editCardDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 73, 75).withOpacity(0.9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/j.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _showCreateListDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 27, 73, 75).withOpacity(0.9),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create new list',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _lists.length,
                  itemBuilder: (context, listIndex) {
                    var listItem = _lists[listIndex];
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 69, 168, 155), 
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          listItem.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Wrap(
                          spacing: 12,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditListDialog(listIndex);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _showArchiveListDialog(listIndex);
                              },
                            ),
                          ],
                        ),
                        children: <Widget>[
                          for (var card in _cards)
                            if (card.idList == _lists[listIndex].id)
                              Container(
                                margin: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 63, 149, 159),
                                  border: Border.all(color: const Color.fromARGB(254, 10, 0, 12)),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: ListTile(
                                  title: Text(card.name),
                                  onTap: () => _showCardDetailsDialog(_cards.indexOf(card)),
                                  trailing: Wrap(
                                    spacing: 12,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _showEditCardDialog(_cards.indexOf(card)),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteCardDialog(_cards.indexOf(card));
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.swap_horiz),
                                        onPressed: () => _moveCardDialog(listIndex, _cards.indexOf(card)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ListTile(
                            title: Center(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text(
                                  'Add Card',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () => _showAddCardDialog(listIndex),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 100, 80, 112),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to show dialog for deleting a card
  // Function to show dialog for deleting a card
void _showDeleteCardDialog(int cardIndex) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Card'),
        backgroundColor: const Color.fromARGB(255, 3, 59, 77), 
        content: const Text('Are you sure you want to delete this card?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.black)),
            onPressed: () async {
              await deleteCard(_cards[cardIndex].id);
              fetchData();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

void _moveCardDialog(int currentListIndex, int currentCardIndex) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Move Card to Another List'),
        backgroundColor: const Color.fromARGB(255, 3, 59, 77), 
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _lists.length,
            itemBuilder: (BuildContext context, int index) {
              // Avoid showing the current list as an option
              if (index == currentListIndex) return Container();
              return ListTile(
                title: Text(_lists[index].name),
                onTap: () async {
                  // Move the card to the selected list
                  await updateCard(_cards[currentCardIndex].id, _lists[index].id, true);
                  fetchData();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Close the dialog
                },
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.black)), 
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

void _showEditCardDialog(int cardIndex) {
  _editCardTitleController.text = _cards[cardIndex].name;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit card'),
        backgroundColor: const Color.fromARGB(255, 3, 59, 77), 
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _editCardTitleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Update', style: TextStyle(color: Colors.black)),
            onPressed: () async {
              if (_editCardTitleController.text.isNotEmpty) {
                await updateCard(_cards[cardIndex].id, _editCardTitleController.text, false);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(); // Close the dialog
                fetchData();
              }
            },
          ),
        ],
      );
    },
  );
}

  // Function to show dialog for card details
  void _showCardDetailsDialog(int cardIndex) {
    CardItem card = _cards[cardIndex];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(card.name),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('card.description'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
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
  // Function to show dialog for creating a new list
  void _showCreateListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 27, 73, 75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), 
          ),
          title: const Text('Create new list'),
          content: TextField(
            controller: _listNameController,
            decoration: const InputDecoration(hintText: 'Name of list'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                final String newName = _listNameController.text;
                if (newName.isNotEmpty) {
                  try {
                    await addList(newName, widget.boardId);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // Close the dialog
                    fetchData(); // Refresh the list of workspaces
                  } catch (e) {
                    showErrorDialog('Failed to create the List: $e');
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

void _showAddCardDialog(int listIndex) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add new card'),
        backgroundColor: const Color.fromARGB(255, 3, 59, 77),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _cardTitleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () async {
              if (_cardTitleController.text.isNotEmpty) {
                try {
                  await addCard(_cardTitleController.text, _lists[listIndex].id);
                  _cardTitleController.clear();
                  Navigator.pop(context); // Close the dialog
                  fetchData(); // Refresh the list of workspaces
                } catch (e) {
                  showErrorDialog('Failed to create the Card: $e');
                }
              } else {
                showErrorDialog('Title cannot be empty.');
              }
            },
          ),
        ],
      );
    },
  );
}

void _showArchiveListDialog(int listIndex) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Archive List'),
        backgroundColor:  const Color.fromARGB(255, 3, 59, 77),
        content: const Text('Are you sure you want to archive this list?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Archive'),
            onPressed: () async {
              try {
                var idList = _lists[listIndex].id;
                await archiveList(idList); // lists can't be deleted in trello
                Navigator.of(context).pop();
                fetchData();
              } catch (e) {
                showErrorDialog("Failed to archive board: $e");
              }
            },
          ),
        ],
      );
    },
  );
}


void _showEditListDialog(int listIndex) {
  TextEditingController nameController = TextEditingController(text: _lists[listIndex].name);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit list name'),
        backgroundColor:  const Color.fromARGB(255, 3, 59, 77),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'New name of list'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Update', style: TextStyle(color: Colors.black)),
            onPressed: () async {
              try {
                var idList = _lists[listIndex].id;
                await updateList(idList, nameController.text);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(); // Close the dialog
                fetchData();
              } catch (e) {
                if (e.toString().contains("List short name is taken")) {
                  showErrorDialog("The list name is already taken. Please choose a different name.");
                } else {
                  var error = e.toString();
                  showErrorDialog("An error occurred while updating the list. -> $error");
                }
              }
            },
          ),
        ],
      );
    },
  );
}

}
