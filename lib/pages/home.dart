import 'package:docs/pages/adding_person.dart';
import 'package:docs/pages/person.dart';
import 'package:docs/pages/person_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:docs/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    void _addPerson() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(color: Colors.grey[900]),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: AddPerson(),
            );
          });
    }

    // String bgImage = data['isDayTime'] ? 'day.png' : 'night.png';
    return StreamProvider<List<PersonDetails>>.value(
      value: DatabaseService().person,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.purple[200],
          ),
          title: Text(
            'Persons',
            style: TextStyle(color: Colors.purple[200]),
          ),
          backgroundColor: Colors.grey[800],
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black87,
          ),
          child: PersonsList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addPerson(),
          child: Icon(
            Icons.person_add,
            color: Colors.purple[200],
          ),
          backgroundColor: Colors.grey[800],
        ),
      ),
    );
  }
}
