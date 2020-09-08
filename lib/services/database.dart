import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/pages/person.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {

  final String uid;
  final String uid1;
  final String subCollection;
  DatabaseService({ this.uid, this.subCollection, this.uid1 });
  
  final CollectionReference personCollection = Firestore.instance.collection('persons');

  Future updatePersonName( String name, String uid) async {
    return await personCollection.document(uid).updateData({
      'name': name
    });
  }

  Future addDownloadUrl(DateTime time, StorageReference _storage, String text) async {
    var downloadUrl = await _storage.getDownloadURL();
    // print(downloadUrl);
    print('in databse');
    print(text);
    print('in databse');
    return await personCollection.document(uid).updateData({
      time.toString(): [downloadUrl,text]
      
    });
  }

  Future deleteDownloadUrl(String fieldName) async {
    StorageReference _storage = FirebaseStorage(storageBucket: 'gs://docs-ac473.appspot.com').ref().child('$uid/$fieldName.png');
    await personCollection.document(uid).updateData({
      fieldName : FieldValue.delete()
    });
    await _storage.delete();
  }



  List<PersonDetails> _printPersonsData(QuerySnapshot snapshot){
    return snapshot.documents.map((e) {
      // print(e.data['picTitles']);
      // for (int i = 0; i < e.data['picTitles'].length; i++){
      //   print(e.data['picTitles'][i]);
      //   personCollection.document(e.documentID).collection(e.data['picTitles'][i]).snapshots().asyncMap((event) {print(event.documents.map((ef) => print(ef.data)));});
      // }
      // print('see there');
      // print(e.data);
      return PersonDetails(name: e.data['name'], uid: e.documentID, data: e.data);
    }).toList();
  }

  Stream<List<PersonDetails>> get person {
    return personCollection.snapshots().map(_printPersonsData);
  }





  // Stream<List> get titleImages {
  //   return personCollection.document(uid).collection(subCollection).snapshots().map((event) => null)
  // }

  // Stream<PersonDetails> get updatePerson {
  //       return personCollection.document(uid).snapshots().map(_personDetails);
  // }

}