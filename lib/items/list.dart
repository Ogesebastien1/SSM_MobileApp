import 'card.dart'; 

class ListData {
  String title;
  List<CardItem> cards;

  ListData({required this.title, this.cards = const []});
}
