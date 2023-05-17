import 'package:flutter/material.dart';
import 'package:prima_prova/home_page.dart';

class AuthMethod extends StatefulWidget {
  const AuthMethod({super.key});

  @override
  State<AuthMethod> createState() => _AuthMethodState();
}

class _AuthMethodState extends State<AuthMethod> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'homepage': (context) => HomePage()},
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Authentication'),
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 60, horizontal: 400),
                    child: Form(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: MaterialButton(
                            height: 80,
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
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: MaterialButton(
                            height: 80,
                            minWidth: double.infinity,
                            onPressed: () {
                              Navigator.pushNamed(context, 'homepage');
                            },
                            child: Text(
                              'ciao',
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
          );
        }
      ),
    );
  }
}
