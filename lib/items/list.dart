import 'card.dart'; 

class ListItem {
  String id;
  String name;
  List<CardData> cards;

  ListItem({required this.id, required this.name, required this.cards});

  factory ListItem.fromMap(Map<String, dynamic> map) {
    return ListItem(
      id: map['id'], //'id' is the key in the response
      name: map['name'],
      cards: [],
    );
  }
}