import 'package:flutter/material.dart';
import 'package:ssm_oversight/items/card.dart';
import 'package:ssm_oversight/items/list.dart';

class BoardPage extends StatefulWidget {
  final String name;

  const BoardPage({Key? key, required this.name}) : super(key: key);

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
  List<ListData> _lists = []; // A list to store multiple lists with cards

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
                    _lists.add(ListData(name: _listNameController.text, cards: []));
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
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.name),
    ),
    body: ListView.builder(
      itemCount: _lists.length,
      itemBuilder: (context, listIndex) {
        var listData = _lists[listIndex];
        return Card(
          child: ExpansionTile(
            title: Text(listData.name),
            children: <Widget>[
              for (var card in listData.cards)
                ListTile(
                  title: Text(card.title),
                  subtitle: Text(card.description),
                  onTap: () => _showCardDetailsDialog(listIndex, listData.cards.indexOf(card)),
                  trailing: Wrap(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditCardDialog(listIndex, listData.cards.indexOf(card)),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _lists[listIndex].cards.removeAt(listData.cards.indexOf(card));
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ListTile(
                title: TextButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Card'),
                  onPressed: () => _showAddCardDialog(listIndex),
                ),
              )
            ],
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _showEditListDialog(listIndex),
            ),
          ),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showCreateListDialog,
      child: Icon(Icons.add),
    ),
  );
}

}
