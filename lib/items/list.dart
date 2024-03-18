class ListItem {
  String id;
  String name;

  ListItem({required this.id, required this.name});

  factory ListItem.fromMap(Map<String, dynamic> map) {
    return ListItem(
      id: map['id'], //'id' is the key in the response
      name: map['name'],
    );
  }
}