import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  String _item;
  String _dateCreated;
  int _id;

  ToDoItem(this._item, this._dateCreated);

  ToDoItem.map(dynamic obj) {
    this._item = obj["itemName"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

  String get itemName => _item;

  String get dateCreated => _dateCreated;

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["itemName"] = _item;
    map["dateCreated"] = _dateCreated;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  ToDoItem.fromMap(Map<String, dynamic> map) {
    this._item = map["itemName"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _item,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.9),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "Created On: $_dateCreated",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13.5,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
