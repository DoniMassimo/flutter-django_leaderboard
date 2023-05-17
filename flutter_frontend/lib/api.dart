import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> login(String name, String password) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/login');

  final jsonData = {
    'name': name,
    'pass': password,
  };

  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(jsonData),
  ); 
  Map<String, dynamic> responseData = jsonDecode(response.body);
  print(responseData);
  return responseData;
}
