import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var apiKey = dotenv.env['API_KEY'];
var apiToken = dotenv.env['SECRET_TOKEN'];
var memberId = dotenv.env['ACCOUNT_ID'];

// get workspaces
Future<http.Response> getWorkspaces() async {

  var url = Uri.parse('https://api.trello.com/1/members/$memberId/organizations?key=$apiKey&token=$apiToken');

  var response = await http.get(url, headers: {
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    return response;
  }

  return jsonDecode(response.statusCode.toString());
}
