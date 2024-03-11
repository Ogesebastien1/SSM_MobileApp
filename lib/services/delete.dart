import "package:http/http.dart" as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Ensure dotenv is loaded before calling these variables.
Future<void> initEnv() async {
  await dotenv.load();
}

var apiKey = dotenv.env['API_KEY'];
var apiToken = dotenv.env['SECRET_TOKEN'];
// var memberId = dotenv.env['ACCOUNT_ID'];


// delete Workspace function
Future<http.Response> deleteWorkspace(String id) async {

  if (id.isEmpty) {
    throw ArgumentError('ID, name or displayName cannot be empty.');
  }

  var url = Uri.https('api.trello.com', '/1/organizations/$id', {
    'key': apiKey,
    'token': apiToken,
  });

  // DELETE request
  var response = await http.delete(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    print('Workspace delete successfully.');
    return response;
  } else {
    throw Exception('Failed to delete workspace: ${response.statusCode} ${response.body}');
  }
}

// delete Board function
Future<http.Response> deleteBoard(String id) async {

  if (id.isEmpty) {
    throw ArgumentError('ID, name or displayName cannot be empty.');
  }

  var url = Uri.https('api.trello.com', '/1/organizations/$id', {
    'key': apiKey,
    'token': apiToken,
  });

  // DELETE request
  var response = await http.delete(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    print('Workspace delete successfully.');
    return response;
  } else {
    throw Exception('Failed to delete workspace: ${response.statusCode} ${response.body}');
  }
}
