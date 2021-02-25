import 'package:flutter/material.dart';
import 'package:notes_app_flutter/db/utilities/color_slider.dart';

enum moreOptions { delete, share, copy }

class MoreOptionsSheet extends StatefulWidget {
  final Color color;
  final DateTime date_last_edited;
  final void Function(Color) callBackColorTapped;

  final void Function(moreOptions) callBackOptionTapped;

  const MoreOptionsSheet(
      {Key key,
        this.color,
        this.date_last_edited,
        this.callBackColorTapped,
        this.callBackOptionTapped})
      : super(key: key);

  @override
  _MoreOptionsSheetState createState() => _MoreOptionsSheetState();
}

class _MoreOptionsSheetState extends State<MoreOptionsSheet> {
  var note_color;

  @override
  void initState() {
    note_color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.note_color,
      child: new Wrap(
        children: <Widget>[
          new ListTile(
              leading: new Icon(Icons.delete, color: Colors.black,),
              title: new Text('Delete notes', style: TextStyle(
                  color: Colors.black,
                  fontSize: 15),),
              onTap: () {
                Navigator.of(context).pop();
                widget.callBackOptionTapped(moreOptions.delete);
              }),
          new ListTile(
              leading: new Icon(Icons.content_copy, color: Colors.black,),
              title: new Text('Duplicate', style: TextStyle(
                  color: Colors.black,
                  fontSize: 15),),
              onTap: () {
                Navigator.of(context).pop();
                widget.callBackOptionTapped(moreOptions.copy);
              }),
          new ListTile(
              leading: new Icon(Icons.share, color: Colors.black,),
              title: new Text('Share', style: TextStyle(
                  color: Colors.black,
                  fontSize: 15),),
              onTap: () {
                Navigator.of(context).pop();
                widget.callBackOptionTapped(moreOptions.share);
              }),
          new Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              height: 44,
              width: MediaQuery.of(context).size.width,
              child: ColorSlider(
                callBackColorTapped: _changeColor,
                // call callBack from notePage here
                noteColor: note_color, // take color from local variable
              ),
            ),
          ),
          // new Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     SizedBox(
          //       height: 44,
          //       child: Center(
          //           child: Text(CentralStation.stringForDatetime(
          //               widget.date_last_edited))),
          //     )
          //   ],
           // mainAxisAlignment: MainAxisAlignment.center,
          //),
          new ListTile()
        ],
      ),
    );
  }

  void _changeColor(Color color) {
    setState(() {
      this.note_color = color;
      widget.callBackColorTapped(color);
    });
  }
}