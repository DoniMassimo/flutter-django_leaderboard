import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:prima_prova/credential.dart' as cr;

Future<Map<String, dynamic>> connectToApi(
    Map<String, dynamic> data, String url) async {
  final finalUrl = Uri.parse('http://127.0.0.1:8000/' + url);

  var response = await http.post(
    finalUrl,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  Map<String, dynamic> responseData =
      jsonDecode(response.body) as Map<String, dynamic>;
  return responseData;
}

Future<Map<String, dynamic>> login(String name, String password) async {
  Map<String, dynamic> responseData =
      await connectToApi({'name': name, 'pass': password}, 'api/login');
  return responseData;
}

Future<List<dynamic>> getGroupName() async {
  Map<String, dynamic> responseData = await connectToApi(
      {'name': cr.Credential.name, 'pass': cr.Credential.password},
      'api/get_group_name');
  return responseData['group_name'];
}

Future<Map<String, dynamic>> getGroupData(String groupName) async {
  Map<String, dynamic> responseData = await connectToApi({
    'name': cr.Credential.name,
    'pass': cr.Credential.password,
    'group_name': groupName
  }, 'api/group_data');
  return responseData;
}

Future<Map<String, dynamic>> updatePoint(
    String personName, String groupName, int newPointValue) async {
  Map<String, dynamic> responseData = await connectToApi({
    'name': cr.Credential.name,
    'pass': cr.Credential.password,
    'group_name': groupName,
    'updated_data': {personName: newPointValue}
  }, 'api/update_point');
  return responseData;
}

Future<List<dynamic>> getJoinedGroup() async {
  Map<String, dynamic> responseData = await connectToApi(
      {'name': cr.Credential.name, 'pass': cr.Credential.password},
      'api/get_joined_group');
  return responseData['joined_group'];
}

Future<List<dynamic>> getJoinRequest(String groupName) async {
  Map<String, dynamic> joinRequest = await connectToApi({
    'name': cr.Credential.name,
    'pass': cr.Credential.password,
    'group_name': groupName
  }, 'api/get_join_req');

  return joinRequest['join_request'];
}

Future<Map<String, dynamic>> getSideBarData() async {
  var fetchedData = await Future.wait([getGroupName(), getJoinedGroup()]);
  Map<String, dynamic> sideBarData = {
    'administred_group': fetchedData[0],
    'joined_group': fetchedData[1]
  };
  return sideBarData;
}
