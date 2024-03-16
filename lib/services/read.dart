import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Ensure dotenv is loaded before calling these variables.
Future<void> initEnv() async {
  await dotenv.load();
}

// get member workspaces
Future<List<dynamic>> getWorkspaces() async {

  final apiKey = dotenv.env['API_KEY'];
  final apiToken = dotenv.env['SECRET_TOKEN'];
  final memberId = dotenv.env['ACCOUNT_ID'];

  if (apiKey == null || apiToken == null || memberId == null) {
    throw Exception('API Key, Token, or Member ID is missing in the .env file.');
  }

  var url = Uri.https('api.trello.com', '/1/members/$memberId/organizations', {
    'key': apiKey,
    'token': apiToken,
  });

  var response = await http.get(url, headers: {
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    return jsonResponse;

  } else {

    throw Exception('Failed to retrieve workspaces: ${response.statusCode} ${response.body}');

  }
}

// get boards of workspace
Future<List<dynamic>> getWorkspaceBoards(String workspaceId) async {

  final apiKey = dotenv.env['API_KEY'];
  final apiToken = dotenv.env['SECRET_TOKEN'];
  //final memberId = dotenv.env['ACCOUNT_ID'];

  if (apiKey == null || apiToken == null) {
    throw Exception('API Key, Token, or Member ID is missing in the .env file.');
  }

  var url = Uri.https('api.trello.com', '/1/organizations/$workspaceId/boards', {
    'key': apiKey,
    'token': apiToken,
  });

  var response = await http.get(url, headers: {
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    return jsonResponse;

  } else {

    throw Exception('Failed to retrieve boards of workspace: ${response.statusCode} ${response.body}');

  }
}

// get lists of board
Future<List<dynamic>> getBoardLists(String boardId) async {

  final apiKey = dotenv.env['API_KEY'];
  final apiToken = dotenv.env['SECRET_TOKEN'];
  //final memberId = dotenv.env['ACCOUNT_ID'];

  if (apiKey == null || apiToken == null) {
    throw Exception('API Key, Token is missing in the .env file.');
  }

  var url = Uri.https('api.trello.com', '/1/boards/$boardId/lists', {
    'key': apiKey,
    'token': apiToken,
  });

  var response = await http.get(url, headers: {
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    return jsonResponse;

  } else {

    throw Exception('Failed to retrieve lists of board: ${response.statusCode} ${response.body}');
  }
}

// get cards of board
//! the cards are not in list but in board.
Future<List<dynamic>> getBoardCards(String boardId) async {

  final apiKey = dotenv.env['API_KEY'];
  final apiToken = dotenv.env['SECRET_TOKEN'];
  //final memberId = dotenv.env['ACCOUNT_ID'];

  if (apiKey == null || apiToken == null) {
    throw Exception('API Key, Token is missing in the .env file.');
  }

  var url = Uri.https('api.trello.com', '/1/boards/$boardId/cards', {
    'key': apiKey,
    'token': apiToken,
  });

  var response = await http.get(url, headers: {
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    return jsonResponse;

  } else {

    throw Exception('Failed to retrieve cards of board: ${response.statusCode} ${response.body}');
  }
}
