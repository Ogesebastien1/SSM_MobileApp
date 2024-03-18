import "package:http/http.dart" as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ssm_oversight/items/board.dart';

// Ensure dotenv is loaded before calling these variables.
Future<void> initEnv() async {
  await dotenv.load();
}

var apiKey = dotenv.env['API_KEY'];
var apiToken = dotenv.env['SECRET_TOKEN'];
// var memberId = dotenv.env['ACCOUNT_ID'];

// create workspace's name
Future<http.Response> addWorkspace(String name) async {

  if (name.isEmpty) {
    throw ArgumentError('Name cannot be empty.');
  }

  var url = Uri.https('api.trello.com', '/1/organizations/', {
    'name': name,
    'displayName': name,
    'key': apiKey,
    'token': apiToken,
  });

  // POST request
  var response = await http.post(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    print('Workspace created successfully.');
    return response;
  } else {
    throw Exception('Failed to create workspace: ${response.statusCode} ${response.body}');
  }
}


// create board
Future<http.Response> addBoard(String name, String workspaceId) async {

  if (name.isEmpty) {
    throw ArgumentError('Name cannot be empty.');
  }

  var url = Uri.https('api.trello.com', '/1/boards/', {
    'idOrganization': workspaceId,
    'name': name,
    'key': apiKey,
    'token': apiToken,  
  });

  // POST request
  var response = await http.post(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    print('Board created successfully.');
    return response;
  } else {
    throw Exception('Failed to create boards: ${response.statusCode} ${response.body}');
  }
}


// Function to create a board from a board template
Future<http.Response> createBoardFromTemplate(String boardTemplateId, String workspaceId, String name) 
async {
  const baseUrl = 'api.trello.com'; 
  const basePath = '/1/boards'; 
  // Load environment variables
  await dotenv.load();
  

  final url = Uri.https(
    baseUrl,
    basePath,
    {
      'idOrganization': workspaceId,
      'idBoardSource': boardTemplateId,
      'name': name,
      'keepFromSource': 'cards',
      'key': apiKey,
      'token': apiToken,
      
    },
  );

  // POST request
  var response = await http.post(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    print('Board created successfully.');
    return response;
  } else {
    throw Exception('Failed to create boards: ${response.statusCode} ${response.body}');
  }
}






// create list
Future<http.Response> addList(String name, String boardId) async {

  if (name.isEmpty) {
    throw ArgumentError('Name cannot be empty.');
  }

  var url = Uri.https('api.trello.com', '/1/lists', {
    'idBoard': boardId,
    'name': name,
    'key': apiKey,
    'token': apiToken,
  });

  // POST request
  var response = await http.post(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    print('List created successfully.');
    return response;
  } else {
    throw Exception('Failed to create List: ${response.statusCode} ${response.body}');
  }
}

// create card
Future<http.Response> addCard(String name, String listId) async {

  if (name.isEmpty) {
    throw ArgumentError('Name cannot be empty.');
  }

  var url = Uri.https('api.trello.com', '/1/cards', {
    'idList': listId,
    'name': name,
    'key': apiKey,
    'token': apiToken,
  });

  // POST request
  var response = await http.post(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    print('Card created successfully.');
    return response;
  } else {
    throw Exception('Failed to create Card: ${response.statusCode} ${response.body}');
  }
}
