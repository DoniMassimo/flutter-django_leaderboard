import 'package:flutter/material.dart';
import 'api.dart' as api;
import 'widget_generator.dart' as wg;

class ViewJoinRequest extends StatefulWidget {
  const ViewJoinRequest({Key? key}) : super(key: key);
  @override
  _ViewJoinRequestState createState() => _ViewJoinRequestState();
}

class _ViewJoinRequestState extends State<ViewJoinRequest> {
  List<Widget> sideBar = [];

  Map<String, List<Map<String, dynamic>>> userData = {};

  Map<dynamic, dynamic> args = {};

  bool firstBulid = true;

  List<dynamic> groupsNames = [];

  List<List<ListTile>> accepRefuseWidgets = [];

  void updateUI() {
    setState(() {});
  }

  @override
  initState() {
    super.initState();
  }

  void setListTileWidget() async {
    List<List<ListTile>> newAccpetRefuseWidget = [];
    groupsNames.forEach((groupName) async {
      newAccpetRefuseWidget.add([]);
      List<dynamic> joinRequest = await api.getJoinRequest(groupName);
      joinRequest.forEach((request) {
        ListTile widget = ListTile(
          title: Text(
            request['person'].toString(),
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await api.acceptJoinRequest(
                              groupName, request['person'], false);
                          setGroupNameValue();
                        },
                        icon: const Icon(Icons.close),
                        color: Color.fromARGB(255, 255, 0, 0),
                        iconSize: 30,
                      ),
                      IconButton(
                        onPressed: () async {
                          await api.acceptJoinRequest(
                              groupName, request['person'], true);
                          setGroupNameValue();
                        },
                        icon: const Icon(Icons.check),
                        color: const Color.fromARGB(255, 163, 255, 167),
                        iconSize: 30,
                      ),
                    ],
                  ))
            ],
          ),
        );
        int index = groupsNames.indexOf(groupName);
        newAccpetRefuseWidget[index].add(widget);
      });
    });
    accepRefuseWidgets.clear();
    accepRefuseWidgets = newAccpetRefuseWidget;
    setState(() {});
  }

  void setGroupNameValue() async {
    groupsNames = await api.getGroupName();
    setState(() {});
    setListTileWidget();
  }

  void setStateCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // args = ModalRoute.of(context)!.settings.arguments as Map;
    if (firstBulid) {
      setGroupNameValue();
      firstBulid = false;
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: wg.generateSidebarRoutes(context),
        home: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Center(child: Text('ViewJoinRequest')),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'view_join_request');
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
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: groupsNames.isNotEmpty
                        ? ListView.builder(
                            itemCount: groupsNames.length,
                            itemBuilder: (context, index) => Card(
                              key: ValueKey(groupsNames[index]),
                              color: Colors.blue,
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ExpansionTile(
                                onExpansionChanged: (value) {
                                  if (value) {}
                                },
                                title: Text(groupsNames[index],
                                    style: const TextStyle(
                                        color:  Colors.white, fontSize: 30)),
                                subtitle: Text(
                                    'Request: ${accepRefuseWidgets[index].length.toString()}',
                                    style: const TextStyle(color: Colors.white)),
                                children: accepRefuseWidgets[index],
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
