import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_flutter/db/db_helper.dart';
import 'package:notes_app_flutter/db/utilities/bottom_sheet.dart';
import 'package:notes_app_flutter/db/utilities/widgets.dart';
import 'package:notes_app_flutter/model/note.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int color;
  bool isEdited = false;

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    color = note.color;
    return WillPopScope(
        onWillPop: () {
          isEdited ? showDiscardDialog(context) : moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              appBarTitle,
              style: TextStyle(
                  fontFamily: 'Sans',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24),
            ),
            backgroundColor: colors[color],
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  isEdited ? showDiscardDialog(context) : moveToLastScreen();
                }),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  titleController.text.length != 0 ?
                  showDeleteDialog(context) : showEmptyTitleDialog(context);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.black,
                ),
                onPressed: () {
                  titleController.text.length == 0
                      ? showEmptyTitleDialog(context)
                      : _save();
                },
              ),
            ],
          ),
          body: Container(
            color: colors[color],
            child: Column(
              children: <Widget>[
                // PriorityPicker(
                //   selectedIndex: 3 - note.priority,
                //   onTap: (index) {
                //     isEdited = true;
                //     note.priority = 3 - index;
                //   },
                // ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: titleController,
                    style: TextStyle(
                        fontFamily: 'Sans',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.black26),
                    ),
                  ),
                ),
                Divider(color: Colors.black26),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: descriptionController,
                      style: TextStyle(
                          fontFamily: 'Sans',
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 18),
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'Description',
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                    ),
                  ),
                ),
                ColorPicker(
                  selectedIndex: note.color,
                  onTap: (index) {
                    setState(() {
                      color = index;
                    });
                    isEdited = true;
                    note.color = index;
                  },
                ),
                SizedBox(height: 15),

              ],
            ),
          ),
        ));
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Discard Changes?",
            style: TextStyle(
                fontFamily: 'Sans',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20),
          ),
          content: Text(
            "Are you sure you want to discard changes?",
            style: TextStyle(
                fontFamily: 'Sans',
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 18),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "No",
                style: TextStyle(
                    fontFamily: 'Sans',
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Yes",
                style: TextStyle(
                    fontFamily: 'Sans',
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void showEmptyTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Empty Field!",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          content: Text('The title of the note cannot be empty.',
              style: Theme.of(context).textTheme.bodyText2),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Ok",
                style: TextStyle(
                    fontFamily: 'Sans',
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete Note?",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: Text("Are you sure you want to delete this note?",
              style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            FlatButton(
              child: Text("No",
                  style: TextStyle(
                      fontFamily: 'Sans',
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 20),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes",
                  style: TextStyle(
                      fontFamily: 'Sans',
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 20),),
              onPressed: () {
                Navigator.of(context).pop();
                _delete();
              },
            ),
          ],
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    isEdited = true;
    note.title = titleController.text;
  }

  void updateDescription() {
    isEdited = true;
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());

    if (note.id != null) {
      await helper.updateNote(note);
    } else {
      await helper.insertNote(note);
    }
  }

  void _delete() async {
    await helper.deleteNote(note.id);
    moveToLastScreen();
  }
}
