class CardItem {
  String id;
  String name;
  String idList;

  CardItem({required this.id, required this.name, required this.idList});

  factory CardItem.fromMap(Map<String, dynamic> map) {
    return CardItem(
      id: map['id'], //'id' is the key in the response
      name: map['name'],
      idList: map['idList'],
    );
  }
}