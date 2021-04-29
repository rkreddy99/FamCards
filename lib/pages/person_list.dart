import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:docs/pages/person.dart';
import 'package:docs/pages/person_tile.dart';

class PersonsList extends StatefulWidget {
  @override
  _PersonsListState createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  @override
  Widget build(BuildContext context) {
    final persons = Provider.of<List<PersonDetails>>(context) ?? [];
    // print(' in person list');
    // print(persons);

    return ListView.builder(
      itemCount: persons.length,
      itemBuilder: (context, index) {
        return PersonTile(
          person: persons[index],
        );
      },
    );
  }
}
