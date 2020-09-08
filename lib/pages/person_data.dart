import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/pages/person.dart';
import 'package:docs/services/add_local_file.dart';
import 'package:docs/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';

class PersonData extends StatefulWidget {

  final PersonDetails person;
  PersonData( {this.person} );
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  _PersonDataState createState() => _PersonDataState();
}

class _PersonDataState extends State<PersonData> {
  @override
  Widget build(BuildContext context) {
    void _deletePhoto (fileName) {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900]
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: RaisedButton.icon(onPressed: () async {
            await DatabaseService(uid: widget.person.uid).deleteDownloadUrl(fileName);
            Navigator.pop(context);
            }, 
            color: Colors.grey[800],
            icon: Icon(Icons.delete_forever, color: Colors.purple[200],), label: Text('Delete image forever', style: TextStyle(color: Colors.purple[200]),)),
        );
      });
    }

    void showText (String text) {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          color: Colors.brown[100],
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: SelectableText(text),
        );
      });
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService().personCollection.document(widget.person.uid).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          var d = snapshot.data.data;
          List imagesList = [];
          List fileNames = [];
          List textList = [];
          d.forEach((key, value) {
            if(key!='name' && key!='picTitles'){
              fileNames.add(key);
              value.forEach((keyd, valued) {
                imagesList.add(valued[0]);
                textList.add(valued[1]);
              });
            }
            }
          );
          return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.purple[200],),
            title: Text('${widget.person.name}', style: TextStyle(color: Colors.purple[200]),),
            backgroundColor: Colors.grey[800],
          ),
          body: Container(
            color: Colors.grey[900],
            child: new GridView.count(
            primary: true,
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            children: List.generate(imagesList.length, (index) {
              return Card(
              semanticContainer: true,
              color: Colors.grey[800],
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                  child: Image.network(
                  imagesList[index],
                  fit: BoxFit.fill,
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Scaffold(
              backgroundColor: Colors.grey[900],
              body: PhotoView(
                    imageProvider: NetworkImage(imagesList[index]),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.grey[900]
                    ),
                  ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.text_fields, color: Colors.purple[200],),
                onPressed: () => showText(textList[index]),
                backgroundColor: Colors.grey[800],
              ),
            );
          },)),
          onLongPress: () {
            _deletePhoto(fileNames[index]);
            print('in Long Press');
            print(fileNames[index].substring(0,19));
            // Navigator.pop(context);
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      );
            }),
        ),
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddImage(person: widget.person,))),
          child: Icon(Icons.add_a_photo, color: Colors.purple[200],),
          backgroundColor: Colors.grey[800],
        ),
        );} else {
          return SpinKitHourGlass(color: Colors.purple[200],);
        }
      }
    );
    }
  }