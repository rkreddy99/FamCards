import 'package:docs/pages/person_data.dart';
import 'package:docs/pages/updating_person.dart';
import 'package:flutter/material.dart';
import 'package:docs/pages/person.dart';

class PersonTile extends StatelessWidget {

  final PersonDetails person;
  PersonTile( {this.person} );

  @override
  Widget build(BuildContext context) {

    void _editPersonName () {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900]
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: UpdatePerson(person: person),
        );
      });
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        color: Colors.grey[800],
        child: InkWell(
          splashColor: Colors.grey[700].withAlpha(60),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PersonData(person: person,))),
          onLongPress: () => _editPersonName(),
          child: ListTile(
            title: Text(person.name, style: TextStyle(color: Colors.orange[300]),),
          ),
        ),
      ),
    );
  }
}