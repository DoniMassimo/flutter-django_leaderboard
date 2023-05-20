import 'package:flutter/material.dart';
import 'api.dart' as api;
import 'leaderboard.dart';
import 'send_request.dart';
import 'create_group.dart';
import 'view_join_request.dart';

void generateSideBar(BuildContext context, List<Widget> sideBar,
    Function setStateCallback) async {
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
      title: Text('View join request'),
      onTap: () {
        Navigator.pushNamed(context, 'view_join_request');
      },
    ),
  );
  listWidget.add(
    ListTile(
      title: Text('Create new group '),
      onTap: () {
        Navigator.pushNamed(context, 'create_group');
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
        Navigator.pushNamed(context, 'send_request');
      },
    ),
  );
  sideBar.replaceRange(0, sideBar.length, listWidget);
  setStateCallback();
}

Map<String, Widget Function(BuildContext)> generateSidebarRoutes(BuildContext context) {
  return {
    'leaderboard': (context) => (const Leaderboard()),
    'send_request': (context) => (const SendRequest()),
    'create_group': (context) => (const CreateGroup()),
    'view_join_request': (context) => (const ViewJoinRequest())
  };
}

