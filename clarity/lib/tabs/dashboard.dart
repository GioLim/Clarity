import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../results.dart';
import 'home.dart';
import 'package:intl/intl.dart';

class Comments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildVertBody(context);
  }

  Widget _buildVertBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Comments')
          .where('id', isEqualTo: id.text)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return buildEmpty();
        return _buildVertList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildVertList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(top: 10.0),
      children:
          snapshot.map((data) => _buildVertListItem(context, data)).toList(),
    );
  }

  Widget _buildVertListItem(BuildContext context, DocumentSnapshot data) {
    return new ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultsPage(query: data['item'])));
      },
      title: new Column(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new SizedBox(
                width: 8.0,
              ),
              new Expanded(
                  child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                      padding: EdgeInsets.all(16.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            data['item'],
                            style: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          new Text(
                            data['comment'],
                            style: new TextStyle(
                                fontSize: 15.0, color: Colors.black87),
                          ),
                          new Text(
                            DateFormat('dd MMM kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(data['timestamp']))),
                            style: new TextStyle(
                                fontSize: 15.0, color: Colors.black87),
                          )
                        ],
                      )),
                ],
              )),
            ],
          ),
          new Divider(),
        ],
      ),
    );
  }

  Widget buildEmpty() {
    return new Container(
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(Icons.comment, size: 150.0, color: Colors.black12),
            new Text('No comments')
          ]),
    );
  }
}