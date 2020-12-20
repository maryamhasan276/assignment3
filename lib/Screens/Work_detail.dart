import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/Models/Work.dart';
import 'package:todo_list/Utils/database_helper.dart';

class WorkDetail extends StatefulWidget {
  final String appBarTitle;
  final Work work;

  WorkDetail(this.work, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return WorkDetailState(this.work, this.appBarTitle);
  }
}

class WorkDetailState extends State<WorkDetail> {

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Work work;

  TextEditingController titleController = TextEditingController();

  WorkDetailState(this.work, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = work.Title;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
               
                  Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title Work',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button");
                              _save();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  
  void updateTitle() {
    work.Title = titleController.text;
  }

 
  void _save() async {
    moveToLastScreen();

    work.Kind = 0;
    int result;
    if (work.Id != null) {
    
      result = await helper.updateworkCompleted(work);
    } else {
      
      result = await helper.insertwork(work);
    }

    if (result != 0) {
      
      _showAlertDialog('Status', ' Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving');
    }
  }

  void _delete() async {
    moveToLastScreen();

   
    if (work.Id == null) {
      _showAlertDialog('Status', 'No thing deleted');
      return;
    }

    
    int result = await helper.deletework(work.Id);
    if (result != 0) {
      _showAlertDialog('Status', ' Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
