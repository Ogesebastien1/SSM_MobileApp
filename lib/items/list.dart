// list.dart
class ListItem {
  final String id;
  final String name;

  ListItem({required this.id, required this.name});

  factory ListItem.fromMap(Map<String, dynamic> map) {
    return ListItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
