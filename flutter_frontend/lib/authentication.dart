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

  // Future<void> call_api() async {
  //   final url = Uri.parse('http://127.0.0.1:8000/api/login');

  //   final jsonData = {
  //     'name': 'John Doe',
  //     'pass': 'ciao',
  //   };

  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(jsonData),
  //   );

  //   //ret = responseData;
  // }

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
                'Login',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 60, horizontal: 100),
                child: Form(
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
                      validator: (value) {
                        return value!.isEmpty ? "Enter the name" : null;
                      },
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter password',
                          prefixIcon: Icon(Icons.password),
                          border: OutlineInputBorder()),
                      onChanged: (value) {},
                      validator: (value) {
                        return value!.isEmpty ? "Enter a password" : null;
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),                    
                      child: MaterialButton(      
                        height: 60,                  
                        minWidth: double.infinity,
                        onPressed: () {},
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 20),
                        ),
                        color: Colors.teal,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                )),
              ),
            ]),
      ),
    );
  }
}
