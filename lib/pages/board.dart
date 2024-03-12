import 'package:flutter/material.dart';
import 'package:ssm_oversight/items/card.dart'; 
import 'package:ssm_oversight/items/list.dart';
import '../services/read.dart';


class BoardPage extends StatefulWidget {
  final String boardId;
  final String name;

  const BoardPage({Key? key, required this.boardId, required this.name}) : super(key: key);

  @override
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

      setState(() {
        _lists = listItems;
      });
    } catch (error) {
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
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _showCreateListDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create new list'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _lists.length,
              itemBuilder: (context, listIndex) {
                var listItem = _lists[listIndex];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(
                      listItem.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditListDialog(listIndex),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteListDialog(listIndex);
                          },
                        ),
                      ],
                    ),
                    children: <Widget>[
                      for (var card in listItem.cards)
                        Container(
                          margin: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.shade100,
                            border: Border.all(color: Colors.purple),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListTile(
                            title: Text(card.title),
                            subtitle: Text(card.description),
                            onTap: () => _showCardDetailsDialog(listIndex, listItem.cards.indexOf(card)),
                            trailing: Wrap(
                              spacing: 12,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showEditCardDialog(listIndex, listItem.cards.indexOf(card)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteCardDialog(listIndex, listItem.cards.indexOf(card));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.swap_horiz),
                                  onPressed: () => _moveCardDialog(listIndex, listItem.cards.indexOf(card)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ListTile(
                        title: Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Add Card'),
                            onPressed: () => _showAddCardDialog(listIndex),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
// Function to show dialog for deleting a card
void _showDeleteCardDialog(int listIndex, int cardIndex) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Card'),
        content: Text('Are you sure you want to delete this card?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              setState(() {
                _lists[listIndex].cards.removeAt(cardIndex);
              });
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
  // Function to move a card to another list
  void _moveCardDialog(int currentListIndex, int cardIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Move Card to Another List'),
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
                  onTap: () {
                    // Move the card to the selected list
                    setState(() {
                      CardData card = _lists[currentListIndex].cards.removeAt(cardIndex);
                      _lists[index].cards.add(card);
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
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
          title: const Text('Create new list'),
          content: TextField(
            controller: _listNameController,
            decoration: const InputDecoration(hintText: 'Name of list'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                if (_listNameController.text.isNotEmpty) {
                  setState(() {
                    _lists.add(ListItem(id: '', name: _listNameController.text, cards: []));
                    _listNameController.clear();
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }
  // Function to show dialog for adding a new card to a list
  void _showAddCardDialog(int listIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _cardTitleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: _cardDescriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
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
              onPressed: () {
                if (_cardTitleController.text.isNotEmpty && _cardDescriptionController.text.isNotEmpty) {
                  setState(() {
                    _lists[listIndex].cards.add(CardData(
                      title: _cardTitleController.text,
                      description: _cardDescriptionController.text,
                    ));
                    _cardTitleController.clear();
                    _cardDescriptionController.clear();
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show dialog for deleting a list
  void _showDeleteListDialog(int listIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete List'),
          content: Text('Are you sure you want to delete this list?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  _lists.removeAt(listIndex);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show dialog for editing a list name
  void _showEditListDialog(int listIndex) {
    _editListNameController.text = _lists[listIndex].name;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit list name'),
          content: TextField(
            controller: _editListNameController,
            decoration: const InputDecoration(hintText: 'New name of list'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                if (_editListNameController.text.isNotEmpty) {
                  setState(() {
                    _lists[listIndex].name = _editListNameController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show dialog for editing a card
  void _showEditCardDialog(int listIndex, int cardIndex) {
    _editCardTitleController.text = _lists[listIndex].cards[cardIndex].title;
    _editCardDescriptionController.text = _lists[listIndex].cards[cardIndex].description;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _editCardTitleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: _editCardDescriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                if (_editCardTitleController.text.isNotEmpty && _editCardDescriptionController.text.isNotEmpty) {
                  setState(() {
                    _lists[listIndex].cards[cardIndex].title = _editCardTitleController.text;
                    _lists[listIndex].cards[cardIndex].description = _editCardDescriptionController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show dialog for card details
  void _showCardDetailsDialog(int listIndex, int cardIndex) {
    CardData card = _lists[listIndex].cards[cardIndex];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(card.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(card.description),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  _lists[listIndex].cards.removeAt(cardIndex);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
