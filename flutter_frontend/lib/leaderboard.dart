import 'package:flutter/material.dart';
import 'api.dart' as api;


class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Widget> sideBar = [];

  List<dynamic> _allUsers = [];

  Map<String, dynamic> userData = {}; 

  Map<dynamic, dynamic> args = {};

  void updateUI() {
    setState(() {});
  }

  void setPosition() {
    for (int i = 0; i < _allUsers.length; i++) {
      _allUsers[i]['pos'] = i + 1;
    }
  }

  void setData(List<dynamic> users, {bool add = true}) {
    // se add è false i dati vengono sovrascritti
    // to put data that are fetched from firebase
    if (add) {
      for (int i = 0; i < users.length; i++) {
        _allUsers.add(users[i]);
      }
    } else {
      _allUsers = users;
    }
    _allUsers.sort((a, b) => b['score'].compareTo(a['score']));
    setPosition();
    setState(() {
      _foundUsers = _allUsers;
    });
  }

  void addScore(int added, {String id = '', String name = ''}) {
    if (id != '' && name != '') {
      var user = _allUsers
          .firstWhere((user) => user['id'] == id && user['name'] == name);
      user['score'] += added;
    }
    _allUsers.sort((a, b) => b['score'].compareTo(a['score']));
    setPosition();
    setState(() {});
    //setScore(added, id, name);
  }

  // This list holds the data for the list view
  List<dynamic> _foundUsers = [];
  @override
  initState() {
    super.initState();
    setStartValue();
    generateSideBar();
  }

  setStartValue() async {
    userData = await api.getGroupData(args['group_name']);
    print('\n\nobject');
    var startVal = [
      {'name': 'max', 'id': 'c@gmail.com', 'score': 10}
    ];
    setData(startVal);
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      _foundUsers = results;
    });
  }

  void generateSideBar() async {
    Map<String, dynamic> sideBarData = await api.getSideBarData();
    List<Widget> listWidget = [];
    List<Widget> adminGroupWidget = [];
    sideBarData['administred_group'].forEach((groupName) {
      adminGroupWidget.add(ListTile(
        title: Text(groupName),
        onTap: () {
          Navigator.pushNamed(context, 'leaderboard',
              arguments: {'group_name': groupName, 'admin': true});
        },
      ));
    });

    List<Widget> joinedGroupWidget = [];

    sideBarData['joined_group'].forEach((groupName) {
      joinedGroupWidget.add(ListTile(
        title: Text(groupName),
        onTap: () {
          Navigator.pushNamed(context, 'leaderboard',
              arguments: {'group_name': groupName, 'admin': false});
        },
      ));
    });

    listWidget.add(
      ExpansionTile(
        title: Text('Administred group'),
        children: adminGroupWidget,
      ),
    );
    listWidget.add(
      ListTile(
        title: Text('Join request'),
        onTap: () {
          // Azione quando viene selezionata l'opzione 2
        },
      ),
    );
    listWidget.add(
      ExpansionTile(
        title: Text('Joined group'),
        children: joinedGroupWidget,
      ),
    );
    listWidget.add(
      ListTile(
        title: Text('Send request'),
        onTap: () {
          // Azione quando viene selezionata l'opzione 2
        },
      ),
    );
    sideBar = listWidget;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map;        
    return MaterialApp(
        routes: {'leaderboard': (context) => (const Leaderboard())},
        home: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Center(child: const Text('Leaderboard')),
            ),
            onDrawerChanged: (isOpened) {
              if (isOpened) {
                generateSideBar();
              }
            },
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                      DrawerHeader(
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
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('go back')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    onChanged: (value) {
                      _runFilter(value);
                    },
                    decoration: const InputDecoration(
                        labelText: 'Search', suffixIcon: Icon(Icons.search)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: _foundUsers.isNotEmpty
                        ? ListView.builder(
                            itemCount: _foundUsers.length,
                            itemBuilder: (context, index) => Card(
                              key: ValueKey(_foundUsers[index]["id"]),
                              color: Colors.blue,
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(children: [
                                          IconButton(
                                            iconSize: 10,
                                            icon: const Icon(
                                              Icons.remove,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => addScore(-1,
                                                id: _foundUsers[index]['id']
                                                    .toString(),
                                                name: _foundUsers[index]
                                                    ['name']),
                                          ),
                                          Text(
                                              _foundUsers[index]['score']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          IconButton(
                                              iconSize: 10,
                                              icon: Icon(
                                                Icons.add,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                              onPressed: () => addScore(1,
                                                  id: _foundUsers[index]['id']
                                                      .toString(),
                                                  name: _foundUsers[index]
                                                      ['name']))
                                        ]))
                                  ],
                                ),
                                leading: Text(
                                  (_foundUsers[index]['pos']).toString(),
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                title: Text(_foundUsers[index]['name'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30)),
                                subtitle: Text(
                                    'Score: ${_foundUsers[index]["score"].toString()}',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )
                        : const Text(
                            'No results found',
                            style: TextStyle(fontSize: 24),
                          ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
