import 'package:flutter/material.dart';
import 'package:flutterapp/model/todoitem.dart';
import 'package:flutterapp/util/database_client.dart';
import 'package:flutterapp/util/dateformatter.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  var db = DatabaseHelper();
  final List<ToDoItem> _itemList = <ToDoItem>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index) {
                  return Card(
                      color: Colors.white,
                      child: ListTile(
                        title: _itemList[index],
                        onLongPress: () => _updateItem(_itemList[index], index),
                        trailing: Listener(
                          key: Key(_itemList[index].itemName),
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.brown,
                          ),
                          onPointerDown: (pointerEvent) =>
                              _deleteToDo(_itemList[index].id, index),
                        ),
                      ));
                }),
          ),
          Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Button",
        backgroundColor: Colors.black,
        child: new ListTile(
          title: Icon(Icons.add),
        ),
        onPressed: _showFormDialog,
      ),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: new Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "Dont Buy Stuff",
                  icon: Icon(Icons.note_add)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _handleSubmit(_textEditingController.text);
            _textEditingController.clear();
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmit(String text) async {
    _textEditingController.clear();
    ToDoItem toDoItem = ToDoItem(text, dateFormatted());
    int saveItemId = await db.saveItem(toDoItem);

    ToDoItem addedItem = await db.getItem(saveItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });

    print(saveItemId);
  }

  _readToDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      ToDoItem toDoItem = ToDoItem.map(item);
      print(toDoItem.itemName);
      setState(() {
        _itemList.add(ToDoItem.map(item));
      });
    });
  }

  _deleteToDo(int id, int index) async {
    debugPrint("");
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(ToDoItem itemList, int index) {
    var alert = AlertDialog(
      title: Text("Update Item"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Item",
                hintText: "eg. Updated Item",
                icon: Icon(Icons.update),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            ToDoItem newUpdatedItem = ToDoItem.fromMap({
              "itemName": _textEditingController.text,
              "dateCreated": dateFormatted(),
              "id": itemList.id
            });
            _handleSubmittedUpdate(index, newUpdatedItem);
            await db.updateItem(newUpdatedItem);
            setState(() {
              _readToDoList();
            });
            Navigator.pop(context);
          },
          child: Text("Update"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, ToDoItem toDoItem) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == toDoItem.itemName;
      });
    });
  }
}
