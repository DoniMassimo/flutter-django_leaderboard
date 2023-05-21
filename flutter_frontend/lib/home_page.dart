import 'package:flutter/material.dart';

import 'widget_generator.dart' as wg;
import 'credential.dart' as cr;

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> sideBar = [];


  void updateUI() {
    setState(() {});
  }


  @override
  initState() {
    super.initState();
  }


  void setStateCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: wg.generateSidebarRoutes(context),
        home: Builder(builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: const Center(child: Text('Leaderboard')),
              ),
              onDrawerChanged: (isOpened) {
                if (isOpened) {
                  wg.generateSideBar(context, sideBar, setStateCallback);
                }
              },
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                        const DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Text(
                            'Sidebar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ] +
                      sideBar,
                ),
              ),
              body: 
                Column(children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Wellcome: ${cr.Credential.name}',
                      style: const TextStyle(
                          fontSize: 40,                          
                          color: Colors.blue),
                    ),
                  ),                  
                ]),
              );
        }));
  }
}
