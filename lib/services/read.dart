import "package:http/http.dart" as http;
import 'dart:convert';

var apiKey="";
var apiToken="";
var memberId="";

// get workspaces
Future<void> getWorkspaces() async {

  var url = Uri.parse('https://api.trello.com/1/members/$memberId/organizations?key=$apiKey&token=$apiToken');

  var response = await http.get(url, headers: {
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
