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
    'name': name,
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
