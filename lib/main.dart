import 'package:flutter/material.dart';
import 'package:todo_list/Screens/Work_list.dart';

import 'Models/Work.dart';
import 'Screens/Work_detail.dart';

void main() {
  runApp(WorkApp());
}

class WorkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      debugShowCheckedModeBanner: false,
      title: 'Works',
      theme: ThemeData.light(),
      home: TabsScreen(),
    );
  }
}

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('works'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All works'),
              Tab(text: 'Complete works'),
              Tab(text: 'InComplete works')
            ],
          ),
        ),
        body: TabBarView(
          children: [WorkList(0), workList(1), WorkList(2)],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint('clicked');
            navigateToDetail(Work('', 0), 'Add work');
          },
          tooltip: 'Add work',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void navigateToDetail(Work todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WorkDetail(todo, title);
    }));
  }
}
