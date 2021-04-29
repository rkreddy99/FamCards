import 'package:docs/pages/person.dart';
import 'package:docs/services/database.dart';
import 'package:flutter/material.dart';
import 'package:docs/services/constant.dart';

class AddPerson extends StatefulWidget {
  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  final _formKey = GlobalKey<FormState>();

  String _currentName;

  @override
  Widget build(BuildContext context) {
    // final persons = Provider.of<List<PersonDetails>>(context) ?? [];
    // print('in updating person');
    // print(persons);

    return StreamBuilder<PersonDetails>(
        stream: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print('snapshot data');
            // print(snapshot.data);
          }
          return Form(
              key: _formKey,
              child: Column(children: [
                Text(
                  'Add Person',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.purple[200],
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),
                  validator: (val) =>
                      val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  color: Colors.grey[800],
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.purple[200]),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await DatabaseService()
                          .personCollection
                          .add({"name": _currentName, "picTitles": []});
                      Navigator.pop(context);
                    }
                  },
                )
              ]));
        });
  }
}
