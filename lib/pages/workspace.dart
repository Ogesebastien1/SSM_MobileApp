import 'package:flutter/material.dart';
import 'package:ssm_oversight/items/board.dart';
import 'package:ssm_oversight/pages/board.dart';


class Workspace extends StatefulWidget {
  const Workspace({super.key, value});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Workspace> {
  List<BoardItem> board = [];

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/backgroundHomePage.jpeg',
          fit: BoxFit.cover,
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          child: SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 150, left: 80, right: 8.0, bottom: 8.0),
                  child: Text(
                    'My Board',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: (board.length / 2).ceil(),
                          itemBuilder: (BuildContext context, int index) {
                            return boardButton(index);
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: (board.length / 2).floor(),
                          itemBuilder: (BuildContext context, int index) {
                            return boardButton(index + (board .length / 2).ceil());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new workspace
          setState(() {
            board.add(BoardItem(name: 'New Board'));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget boardButton(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Edit Board'),
                      onTap: () {
                        // Implement edit functionality here
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete Board'),
                      onTap: () {
                        // Implement delete functionality here
                        Navigator.pop(context);
                      },
                    ),
                     ListTile(
                      leading: const Icon(Icons.open_in_browser),
                      title: const Text('Open Board'),
                      onTap: () {
                        Navigator.pop(context); // Close the bottom sheet
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoardPage(name: board[index].name),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              board[index].name,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}