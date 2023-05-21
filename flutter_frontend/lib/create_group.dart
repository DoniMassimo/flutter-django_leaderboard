import 'package:flutter/material.dart';
import 'widget_generator.dart' as wg;
import 'api.dart' as api;

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<Widget> sideBar = [];

  Map<dynamic, dynamic> args = {};

  bool firstBulid = true;

  String groupName = '';

  String apiResult = '';

  MaterialColor apiResultColor = Colors.red;

  @override
  initState() {
    super.initState();
  }

  void setStateCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (firstBulid) {
      firstBulid = false;
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: wg.generateSidebarRoutes(context),
        home: Builder(builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: const Center(child: Text('CreateGroup')),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'create_group');
                      },
                      icon: const Icon(Icons.refresh))
                ],
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
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Create group',
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 60, horizontal: 100),
                        child: Form(
                            child: Column(children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                                labelText: 'Group name',
                                hintText: 'Enter group name',
                                prefixIcon: Icon(Icons.group),
                                border: OutlineInputBorder()),
                            onChanged: (value) {
                              groupName = value;
                            },
                          ),
                          const SizedBox(height: 40),
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: MaterialButton(
                              height: 60,
                              minWidth: double.infinity,
                              onPressed: () async {
                                Map<String, dynamic> res = await api.createGroup(groupName);
                                if (res.containsKey('correct')) {
                                  apiResult = res['correct'];
                                  apiResultColor = Colors.green;
                                }
                                else if (res.containsKey('error')) {
                                  apiResult = res['error'];
                                  apiResultColor = Colors.red;
                                }                                
                                setState(() {
                                  
                                });
                              },
                              child: Text(
                                'Create group',
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
                            apiResult,
                            style: TextStyle(
                                color: apiResultColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ))
                        ])))
                  ]));
        }));
  }
}
