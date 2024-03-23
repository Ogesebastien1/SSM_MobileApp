import "package:http/http.dart" as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Ensure dotenv is loaded before calling these variables.
Future<void> initEnv() async {
  await dotenv.load();
}

var apiKey = dotenv.env['API_KEY'];
var apiToken = dotenv.env['SECRET_TOKEN'];
// var memberId = dotenv.env['ACCOUNT_ID'];

// update workspace's name
Future<http.Response> updateWorkspaceName(String id, String name) async {

  if (id.isEmpty || name.isEmpty) {
    throw ArgumentError('ID and name cannot be empty.');
  }

  var url = Uri.https('api.trello.com', '/1/organizations/$id', {
    'displayName': name,
    'key': apiKey,
    'token': apiToken,
  });

  // PUT request
  var response = await http.put(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    print('Workspace updated successfully.');
    return response;
  } else {
    throw Exception('Failed to update workspace: ${response.statusCode} ${response.body}');
  }
}

// update boards name
Future<http.Response> updateBoard(String idBoard, String name) async {

  if (idBoard.isEmpty || name.isEmpty) {
    throw ArgumentError('ID and name cannot be empty.');
  }

  var url = Uri.https('api.trello.com', '/1/boards/$idBoard', {
    'name': name,
    'key': apiKey,
    'token': apiToken,
  });

  // PUT request
  var response = await http.put(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    print('Board updated successfully.');
    return response;
  } else {
    throw Exception('Failed to update Board : ${response.statusCode} ${response.body}');
  }
}
// update list name
Future<void> updateList(String idList, String name) async {
  if (idList.isEmpty || name.isEmpty) {
    throw ArgumentError('ID and name cannot be empty.');
  }

  try {
    var url = Uri.https('api.trello.com', '/1/lists/$idList', {
      'name': name,
      'key': apiKey,
      'token': apiToken,
    });

    var response = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      print('List updated successfully.');
    }

  } catch (e) {
    throw Exception('Failed to update list: $e');
  }
}

// archive list function
Future<http.Response> archiveList(String idList) async {
  
  if (idList.isEmpty) {
    throw ArgumentError('ID cannot be empty.');
  }

  var url = Uri.https('api.trello.com', '/1/lists/$idList', {
    'closed': 'true',
    'key': apiKey,
    'token': apiToken,
  });

  // PUT request
  var response = await http.put(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    print('list archived successfully.');
    return response;
  } else {
    throw Exception('Failed to archive list: ${response.statusCode} ${response.body}');
  }
}

// update card name
Future<void> updateCard(String idCard, String nameOrIdList, bool moving) async {
  if (!moving){
    if (idCard.isEmpty || nameOrIdList.isEmpty) {
      throw ArgumentError('ID and name cannot be empty.');
    }

    try {
      var url = Uri.https('api.trello.com', '/1/cards/$idCard', {
        'name': nameOrIdList,
        'key': apiKey,
        'token': apiToken,
      });

      var response = await http.put(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        print('Card updated successfully.');
      }

    } catch (e) {
      throw Exception('Failed to update card: $e');
    }
  }else {
    if (idCard.isEmpty || nameOrIdList.isEmpty) {
      throw ArgumentError('IDs cannot be empty.');
    }

    try {
      var url = Uri.https('api.trello.com', '/1/cards/$idCard', {
        'idList': nameOrIdList,
        'key': apiKey,
        'token': apiToken,
      });

      var response = await http.put(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        print('Card updated successfully.');
      }

    } catch (e) {
      throw Exception('Failed to update card: $e');
    }
  }
}

// update card name
Future<void> updateCardMembers(String idCard, List<dynamic> idMembers) async {
  if (idCard.isEmpty || idMembers.isEmpty) {
    throw ArgumentError('ID and name cannot be empty.');
  }

  try {
    var url = Uri.https('api.trello.com', '/1/cards/$idCard', {
      'idMembers': idMembers,
      'key': apiKey,
      'token': apiToken,
    });

    var response = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      print('Card updated successfully.');
    }

  } catch (e) {
    throw Exception('Failed to update card: $e');
  }
}
