// card.dart
class CardItem {
  final String id;
  final String idList;
  final String name;
  final String description;

  CardItem({required this.id, required this.idList, required this.name, required this.description});

  factory CardItem.fromMap(Map<String, dynamic> map) {
    return CardItem(
      id: map['id'] ?? '',
      idList: map['idList'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idList': idList,
      'name': name,
      'description': description,
    };
  }
}
