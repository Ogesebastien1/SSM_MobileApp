import 'package:flutter/material.dart';

class CardData {
  String title;
  String description;

  CardData({required this.title, required this.description});
}

class BoardPage extends StatefulWidget {
  final String name;

  const BoardPage({Key? key, required this.name}) : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<CardData> _cards = []; // Liste pour stocker les données des cartes

  @override
  void dispose() {
    _listNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showCreateListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create new list'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _listNameController,
                decoration: const InputDecoration(hintText: 'Name of list'),
              ),
              TextField(
                controller: _descriptionController,
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
              child: const Text('Create'),
              onPressed: () {
                if (_listNameController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
                  // Add the new card data to the cards list
                  setState(() {
                    _cards.add(CardData(
                      title: _listNameController.text,
                      description: _descriptionController.text,
                    ));
                  });
                  // Clear the text fields after use
                  _listNameController.clear();
                  _descriptionController.clear();
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showCardDetailsDialog(CardData card) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Text(card.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(card.description),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Logique pour supprimer la carte
                  setState(() {
                    _cards.remove(card);
                  });
                  Navigator.pop(context);
                },
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name), // Affiche le nom du tableau dans l'AppBar
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _showCreateListDialog,
              icon: const Icon(Icons.add),
              label: const Text('Create new list'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(card.title),
                    subtitle: Text(card.description),
                    onTap: () => _showCardDetailsDialog(card),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
