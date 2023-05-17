import 'package:flutter/material.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _allUsers = [];

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
  }

  setStartValue() async {
    //List<dynamic> startval = await getAllUsersData();
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
  // List<Widget> returnPlusMinus(){

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Franco gay leaderboard')),
      ),
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
            ListTile(
              title: Text('My group'),
              onTap: () {
                // Azione quando viene selezionata l'opzione 1
              },
            ),
            ListTile(
              title: Text('Join request'),
              onTap: () {
                // Azione quando viene selezionata l'opzione 2
              },
            ),
            ListTile(
              title: Text('Joined group'),
              onTap: () {
                // Azione quando viene selezionata l'opzione 3
              },
            ),
            ExpansionTile(
              title: Text('My group'),
              children: <Widget>[
                ListTile(
                  title: Text('Sotto-opzione 1'),
                  onTap: () {
                    // Azione quando viene selezionata la sotto-opzione 1
                  },
                ),
                ListTile(
                  title: Text('Sotto-opzione 2'),
                  onTap: () {
                    // Azione quando viene selezionata la sotto-opzione 2
                  },
                ),
              ],
            ),
            ListTile(
              title: Text('Opzione 3'),
              onTap: () {
                // Azione quando viene selezionata l'opzione 3
              },
            ),
          ],
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
                                          name: _foundUsers[index]['name']),
                                    ),
                                    Text(_foundUsers[index]['score'].toString(),
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
                                            name: _foundUsers[index]['name']))
                                  ]))
                            ],
                          ),
                          leading: Text(
                            (_foundUsers[index]['pos']).toString(),
                            style: const TextStyle(
                                fontSize: 30, color: Colors.white),
                          ),
                          title: Text(_foundUsers[index]['name'],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30)),
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
  }
}

