import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:todo_list/Models/Work.dart';
import 'package:todo_list/Utils/database_helper.dart';

class WorkList extends StatefulWidget {
  int kind = 0;
  WorkList(int kind) {
    this.kind = kind;
  }
  @override
  _WorkListState createState() => _WorkListState();
}

class _WorkListState extends State<WorkList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Work> workList;

  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (workList == null) {
     workList = List<Work>();
      updateListView();
    }

    return Center(
      child: getworkListView(),
    );
  }

  ListView getworkListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.workList[position].Title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.workList[position].Title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    _delete(context, workList[position]);
                  },
                ),
                Checkbox(
                  value: workList[position].Kind == 2,
                  onChanged: (value) {
                    if (workList[position].Kind == 1) {
                      _changeTypeCompleted(context, workList[position]);
                    } else if (workList[position].Kind == 2) {
                      _changeTypeInCompleted(context, workList[position]);
                    }
                  },
                )
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              // navigateToDetail(this.workList[position], 'Edit');
            },
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Work work) async {
    int result = await databaseHelper.deletework(work.Id);
    if (result != 0) {
      _showSnackBar(context, ' Deleted Successfully');
      updateListView();
    }
  }

  void _changeTypeCompleted(BuildContext context, Work work) async {
    int result = await databaseHelper.updateworkCompleted(work);
    if (result != 0) {
      _showSnackBar(context, ' Completed Successfully');
      updateListView();
    }
  }

  void _changeTypeInCompleted(BuildContext context, Work work) async {
    int result = await databaseHelper.updateworkInCompleted(work);
    if (result != 0) {
      _showSnackBar(context, ' InCompleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Work>> todoListFuture = databaseHelper.getworkList(0);
      todoListFuture.then((todoList) {
        setState(() {
          this.workList = workList;
          this.count = workList.length;
        });
      });
    });
  }
}
