import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => AuthenticationState();
}

class AuthenticationState extends State<Authentication> {
  String ret = '';

  Future<void> call_api() async {    
    final url = Uri.parse('http://127.0.0.1:8000/api/login');

    final jsonData = {
      'name': 'John Doe',
      'pass': 'ciao',
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jsonData),
    );

    ret = response.body;
    //ret = responseData;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Authentication'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ret,
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold),
            ),
            Form(
                child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder()),
                  onChanged: (value) {},
                )
              ],
            )),
            ElevatedButton(
                onPressed: () {                  
                  call_api();
                },
                child: const Text('pigia'))
          ],
        ),
      ),
    );
  }
}
