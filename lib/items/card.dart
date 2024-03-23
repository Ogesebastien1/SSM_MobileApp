class CardItem {
  String id;
  String name;
  String idList;
  List<dynamic> memberIds;

  CardItem({required this.id, required this.name, required this.idList, required this.memberIds});

  factory CardItem.fromMap(Map<String, dynamic> map) {
    return CardItem(
      id: map['id'], //'id' is the key in the response
      name: map['name'],
      idList: map['idList'],
      memberIds: (map['idMembers'] as List<dynamic>?) ?? [],
    );
  }
}