import 'package:flutter/material.dart';
import 'package:prima_prova/home_page.dart';
import 'api.dart' as api;
import 'credential.dart' as cr;

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => AuthenticationState();
}

class AuthenticationState extends State<Authentication> {
  String name = '';
  String password = '';

  String error = '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return MaterialApp(
      routes: {'home_page': (context) => HomePage()},
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(args),
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  args,
                  style: const TextStyle(
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
                        decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter name',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter password',
                            prefixIcon: Icon(Icons.password),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: MaterialButton(
                          height: 60,
                          minWidth: double.infinity,
                          onPressed: () async {
                            if (name == '') {
                              setState(() {
                                error = 'Insert a name';
                              });
                              return;
                            } else if (password == '') {
                              setState(() {
                                error = 'Insert a password';
                              });
                              return;
                            }
                            Map<String, dynamic> res = {};
                            if (args == 'register') {
                              res = await api.register(name, password);
                            } else if (args == 'login') {
                              res = await api.login(name, password);
                            }

                            if (res.containsKey('error')) {
                              setState(() {
                                error = res['error'];
                              });
                            } else if (res.containsKey('correct')) {
                              cr.Credential.name = name;
                              cr.Credential.password = password;
                              Navigator.pushNamed(
                                context,
                                'home_page',
                              );
                            }
                            setState(() {
                              
                            });
                          },
                          child: Text(
                            args,
                            style: TextStyle(fontSize: 20),
                          ),
                          color: Colors.teal,
                          textColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Text(
                          error,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )),
                ),
              ]),
        );
      }),
    );
  }
}
