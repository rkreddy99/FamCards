import 'package:docs/pages/person.dart';
import 'package:docs/services/database.dart';
import 'package:flutter/material.dart';
import 'package:docs/services/constant.dart';

class UpdatePerson extends StatefulWidget {

  final PersonDetails person;
  UpdatePerson({ this.person });

  @override
  _UpdatePersonState createState() => _UpdatePersonState();
}

class _UpdatePersonState extends State<UpdatePerson> {

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
        if(snapshot.hasData){
          // print('snapshot data');
          // print(snapshot.data);
        }
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Rename',
                style: TextStyle(fontSize: 20, color: Colors.purple[200], fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
              TextFormField(
                initialValue: widget.person.name,
                decoration: textInputDecoration.copyWith(hintText: 'Name'),
                validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                onChanged: (val) => setState(() => _currentName = val),
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.grey[800],
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.purple[200]),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    await DatabaseService(uid: widget.person.name).updatePersonName(
                      _currentName ?? widget.person.name, 
                      widget.person.uid
                    );
                    Navigator.pop(context);
                  }
                },
              ),
              SizedBox(height: 30,),
              Text(
                'Delete the user',
                style: TextStyle(fontSize: 20, color: Colors.purple[200], fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
              RaisedButton.icon(
                onPressed: () async {
                  await DatabaseService().personCollection.document(widget.person.uid).delete();
                  Navigator.pop(context);
                }, 
                icon: Icon(Icons.delete, color: Colors.purple[200],), 
                label: Text('Delete User', style: TextStyle(color: Colors.purple[200]),),
                color:  Colors.grey[800],
                )
            ]
          )
        );
      }
    );
  }
}