import 'package:flutter/material.dart';
import 'api.dart' as api;
import 'widget_generator.dart' as wg;

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Widget> sideBar = [];

  List<dynamic> _allUsers = [];

  Map<String, List<Map<String, dynamic>>> userData = {};

  Map<dynamic, dynamic> args = {};

  bool firstBulid = true;

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
    _allUsers.sort((a, b) => b['point'].compareTo(a['point']));
    setPosition();
    setState(() {
      _foundUsers = _allUsers;
    });
  }

  void addPoint(int added, {String id = '', String name = ''}) {
    if (_allUsers[0]['id'] == id) {}
    int newPointValue = 0;
    if (id != '' && name != '') {
      var user = _allUsers.firstWhere((user) =>
          user['id'].toString() == id && user['name'].toString() == name);
      user['point'] += added;
      newPointValue = user['point'];
    }
    _allUsers.sort((a, b) => b['point'].compareTo(a['point']));
    setPosition();
    setState(() {});
    api.updatePoint(name, args['group_name'], newPointValue);
  }

  // This list holds the data for the list view
  List<dynamic> _foundUsers = [];
  @override
  initState() {
    super.initState();
  }

  setStartValue() async {
    Map<String, dynamic> userData =
        Map.from(await api.getGroupData(args['group_name']));
    List<Map<String, dynamic>> startVal = [];
    for (int i = 0; i < userData['user']!.length; i++) {
      int id = userData['user']![i]['id'];
      startVal.add({
        'name': userData['user']![i]['name'],
        'id': id,
        'point': userData['point']!
            .firstWhere((element) => element['person'] == id)['point']
      });
    }
    setData(startVal, add: false);
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

  void setStateCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map;
    if (firstBulid) {
      setStartValue();
      firstBulid = false;
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: wg.generateSidebarRoutes(context),
        home: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text(args['group_name'])),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'leaderboard', arguments: {
                        'group_name': args['group_name'],
                        'admin': args['admin']
                      });
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
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
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
                                      child: args['admin'] == true
                                          ? Row(children: [
                                              IconButton(
                                                iconSize: 10,
                                                icon: const Icon(
                                                  Icons.remove,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () => addPoint(-1,
                                                    id: _foundUsers[index]['id']
                                                        .toString(),
                                                    name: _foundUsers[index]
                                                        ['name']),
                                              ),
                                              Text(
                                                  _foundUsers[index]['point']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                              IconButton(
                                                  iconSize: 10,
                                                  icon: const Icon(
                                                    Icons.add,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () => addPoint(1,
                                                      id: _foundUsers[index]
                                                              ['id']
                                                          .toString(),
                                                      name: _foundUsers[index]
                                                          ['name']))
                                            ])
                                          : Text(
                                              _foundUsers[index]['point']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                    )
                                  ],
                                ),
                                leading: Text(
                                  (_foundUsers[index]['pos']).toString(),
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                title: Text(_foundUsers[index]['name'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 30)),
                                subtitle: Text(
                                    'Score: ${_foundUsers[index]["point"].toString()}',
                                    style: const TextStyle(color: Colors.white)),
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
