import 'package:flutter/material.dart';
import 'package:ssm_oversight/items/card.dart'; 
import 'package:ssm_oversight/items/list.dart';
import 'package:ssm_oversight/items/member.dart';
import '../services/read.dart';
import '../services/update.dart';
import '../services/create.dart';
import '../services/delete.dart';

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
  List<MemberItem> _boardMembers = [];
  List<ListItem> _lists = [];
  List<CardItem> _cards = [];
  // ignore: prefer_typing_uninitialized_variables
  var memberShowFullName;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      List<dynamic> memberMaps = await getBoardMembers(widget.boardId);
      List<MemberItem> memberItems = memberMaps.map((memberMap){
        return MemberItem.fromMap(memberMap as Map<String, dynamic>);
      }).toList();

      List<dynamic> listMaps = await getBoardLists(widget.boardId);
      List<ListItem> listItems = listMaps.map((listMap) {
        return ListItem.fromMap(listMap as Map<String, dynamic>);
      }).toList();

      List<dynamic> cardMaps = await getBoardCards(widget.boardId);
      List<CardItem> cardItems = cardMaps.map((cardMap) {
        return CardItem.fromMap(cardMap as Map<String, dynamic>);
      }).toList();

      setState(() {
        _boardMembers = memberItems;
        _cards = cardItems;
        _lists = listItems;
        memberShowFullName = false;
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
                          onPressed: () {
                            _showEditListDialog(listIndex);
                          } 
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
                              color: Colors.lightBlue.shade100,
                              border: Border.all(color: Colors.purple),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: ListTile(
                              title: Text(card.name),
                              //subtitle: Text(card.description),
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
void _showDeleteCardDialog(int cardIndex) {
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
            onPressed: () async{
              await deleteCard(_cards[cardIndex].id);
              fetchData();
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
  // Function to move a card to another list
  void _moveCardDialog(int currentListIndex, int currentCardIndex) {
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
                  onTap: () async {
                    var idList = _lists[index].id;
                    print('idList => $idList');
                    // Move the card to the selected list
                    await updateCard(_cards[currentCardIndex].id, _lists[index].id, true);
                    fetchData();
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
              onPressed: () async {
                final String newName = _listNameController.text;
                if (newName.isNotEmpty) {
                  try {
                    await addList(newName, widget.boardId);
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
              // TextField(
              //   controller: _cardDescriptionController,
              //   decoration: const InputDecoration(hintText: 'Description'),
              // ),
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
                // && _cardDescriptionController.text.isNotEmpty
                if (_cardTitleController.text.isNotEmpty) {
                  try {
                    await addCard(_cardTitleController.text, _lists[listIndex].id);
                    _cardTitleController.clear();
                    //_cardDescriptionController.clear();
                    Navigator.pop(context); // Close the dialog
                    fetchData(); // Refresh the list of workspaces
                  } catch (e) {
                    showErrorDialog('Failed to create the Card: $e');
                  }
                } else {
                  showErrorDialog('Title cannot be empty.');
                }
              }
            ),
          ],
        );
      },
    );
  }

  // Function to show dialog for deleting a list
  void _showArchiveListDialog(int listIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Archive List'),
          content: Text('Are you sure you want to archive this list?'),
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
                  // ignore: use_build_context_synchronously
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

  // Function to show dialog for editing a list name
  void _showEditListDialog(int listIndex) {
    TextEditingController nameController = TextEditingController(text: _lists[listIndex].name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit list name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'New name of list'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Update'),
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

  // Function to show dialog for editing a card
  void _showEditCardDialog(int cardIndex) {
    _editCardTitleController.text = _cards[cardIndex].name;
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
              // TextField(
              //   controller: _editCardDescriptionController,
              //   decoration: const InputDecoration(hintText: 'Description'),
              // ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                //&& _editCardDescriptionController.text.isNotEmpty
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
    var cardMembers = _cards[cardIndex].memberIds;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(card.name),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      for (var i = 0; i < cardMembers.length; i++)
                        for (var boardMember in _boardMembers)
                          if (cardMembers[i] == boardMember.id)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  memberShowFullName = !memberShowFullName;
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  memberShowFullName ? boardMember.fullName : boardMember.initials,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Assign/Unassign'),
                                content: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          const Text('Assigned members', style: TextStyle(fontWeight: FontWeight.bold)),
                                          for (var i = 0; i < cardMembers.length; i++)
                                            for (var boardMember in _boardMembers)
                                              if (cardMembers[i] == boardMember.id)
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      cardMembers.remove(boardMember.id); // Remove the member id from the list
                                                      updateCardMembers(_cards[cardIndex].id, cardMembers); // Update the card members
                                                    });
                                                  },
                                                  child: Text(boardMember.fullName),
                                                ),
                                        ],
                                      ),
                                      const Divider(), // Line in the middle
                                      Column(
                                        children: <Widget>[
                                          const Text('Unassigned members', style: TextStyle(fontWeight: FontWeight.bold)),
                                          for (var boardMember in _boardMembers)
                                            if (!cardMembers.contains(boardMember.id))
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    cardMembers.add(boardMember.id); // Remove the member id from the list
                                                    updateCardMembers(_cards[cardIndex].id, cardMembers); // Update the card members
                                                  });
                                                },
                                                child: Text(boardMember.fullName),
                                              ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Text('card.description'),
              ],
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
}
